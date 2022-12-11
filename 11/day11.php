<?php
    // Task 1 executed with: php ./day11.php input.txt 3 20
    // Task 2 executed with: php ./day11.php input.txt 3 10000

    $filename = $argv[1];
    $filecontent = file_get_contents($filename);
    $lines = explode("\n", $filecontent);
    const segment_size = 7;
    const item_val_start_index = 4;
    const operator_index = 6;
    const rh_operand_index = 7;
    const throw_target_index = 9;

    class Monkey {        
        public function __construct($initial_items, $is_operation_add, $rh_operand,
            $divisor, $throw_target_true, $throw_target_false, $worry_diminish_factor) {
            $this->monkey_index = Monkey::$monkey_count;
            Monkey::$monkey_count++;

            array_push($this->items, ...$initial_items);
            $this->is_operation_add = $is_operation_add;
            $this->rh_operand = $rh_operand;
            $this->test_divisor = $divisor;
            $this->target_true = $throw_target_true;
            $this->target_false = $throw_target_false;

            Monkey::$worry_diminish_factor = $worry_diminish_factor;
        }

        public function addItem($item) {
            array_push($this->items, $item);
        }

        public function throwItems() {
            foreach ($this->items as &$item) {
                $this->throwItem($item);
            }
            // clear items
            $this->items = array();
        }

        public function __toString()
        {
            $items_string = "";
            foreach ($this->items as $item_index=>$item) {
                $items_string = $items_string . $item . " ";
            }
            return "Monkey $this->monkey_index threw $this->throw_count times.";
        }

        private function throwItem($item) {
            $worry_level = $this->is_operation_add ? bcadd($item, 
                ($this->rh_operand == "old" ? $item : $this->rh_operand))
                : bcmul($item,
                ($this->rh_operand == "old" ? $item : $this->rh_operand));
            $worry_level = bcdiv($worry_level, Monkey::$worry_diminish_factor);
                
            if (bcmod($worry_level, $this->test_divisor) == "0") {
                Monkey::$monkeys[$this->target_true]->addItem(
                    $worry_level);
            } else {
                Monkey::$monkeys[$this->target_false]->addItem(
                    $worry_level);
            }

            $this->throw_count++;
        }

        public function getThrowCount() {
            return $this->throw_count;
        }

        private static $monkey_count = 0;
        private static $worry_diminish_factor;
        public static $monkeys = []; // array of Monkey instances

        private $is_operation_add;
        private $rh_operand;
        private $test_divisor;
        private $target_true;
        private $target_false;
        private $monkey_index;
        private $items = [];
        private $throw_count = 0;
    }

    $curr_monkey = 0;
    $curr_monkey_items = [];
    $is_operation_add;
    $rh_operand;
    $divisor;
    $throw_target_true;
    $throw_target_false;

    foreach ($lines as $index=>&$line) {
        if ($index % segment_size == 1) {
            $items = explode(" ", $line);
                  
            foreach ($items as $item_index=>&$item) {
                if ($item_index >= item_val_start_index) {
                   $curr_monkey_items[] = (int)$item; // int cast removes possible leading comma
                }
            }          
            continue;
        }

        if ($index % segment_size == 2) {
            $items = explode(" ", $line);
            $is_operation_add = $items[operator_index] == "+"
                ? true
                : false;
            $rh_operand = $items[rh_operand_index];
        }

        if ($index % segment_size == 3) {
            $items = explode(" ", $line);
            $divisor = (int)($items[5]);
        }

        if ($index % segment_size == 4) {
            $items = explode(" ", $line);
            $throw_target_true = $items[throw_target_index];
        }

        if ($index % segment_size == 5) {
            $items = explode(" ", $line);
            $throw_target_false = $items[throw_target_index];
        }

        if ($index % segment_size == 6) {
            Monkey::$monkeys[] = new Monkey($curr_monkey_items, $is_operation_add,
                $rh_operand, $divisor, $throw_target_true, $throw_target_false, $argv[2]);
            $curr_monkey_items = array();
        }
    }

    $time_start = microtime(true); 

    for ($i = 0; $i < $argv[3]; $i++) {
       foreach (Monkey::$monkeys as &$monkey) {
           $monkey->throwItems();
       }
    }

    $time_end = microtime(true);
    $execution_time = floor(($time_end - $time_start));
    echo("Took $execution_time seconds to compute.\n");

    $throw_leaderboards = [];

    foreach (Monkey::$monkeys as &$monkey) {
        $throw_leaderboards[] = $monkey->getThrowCount();
        echo($monkey . "\n");
    }

    // sort descending
    usort($throw_leaderboards, fn($lhs, $rhs) => -1 * ($lhs <=> $rhs));
    $monkey_business = bcmul($throw_leaderboards[0], $throw_leaderboards[1]);
    echo("Monkey business: $monkey_business\n");
?>
