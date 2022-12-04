use strict;
use warnings;

sub get_full_contains {
    my $input_file = $_[0];
    open my $file_content, $input_file or die "Cannot open file $input_file";

    my $fully_sum = 0;
    my $partial_or_full_sum = 0;

    # <$file_content> is shorthand for readLine($file_content)
    while (my $line = <$file_content>) {
        my @sections_pair = split(",", $line);
        my @section_1 = split("-", $sections_pair[0]);
        my @section_2 = split("-", $sections_pair[1]);

        # Section 1 is fully contained within Section 2
        if ($section_1[0] >= $section_2[0] && $section_1[1] <= $section_2[1]) {
            $fully_sum++;
            $partial_or_full_sum++;
            next;
        }
        # Section 2 is fully contained within Section 1
        if ($section_2[0] >= $section_1[0] && $section_2[1] <= $section_1[1]) {
            $fully_sum++;
            $partial_or_full_sum++;
            next;
        }
        # Section 1's lower bound intersects with Section 2
        if ($section_1[0] >= $section_2[0] && $section_1[0] <= $section_2[1]) {
            $partial_or_full_sum++;
            next;
        }
        # Section 1's upper bound intersects with Section 2
        if ($section_1[1] <= $section_2[1] && $section_1[1] >= $section_2[0]) {
            $partial_or_full_sum++;
            next;
        }
    }

    return ($fully_sum, $partial_or_full_sum);
}

sub main {
    my @full_contains = get_full_contains("./input.txt");
    print "There is a full overlap in $full_contains[0] pair\n";
    print "There is at least a partial overlap in $full_contains[1] pair";

    return 0;
}

main();
