#!/bin/bash

# Set the number of iterations
iterations=5

# Array to store thread numbers
thread_numbers=(1 2 4 6 8 10 12 14 16 18 20 22 24)

# Array to store average time differences
average_times=()
rm -f output.txt
for threads in "${thread_numbers[@]}"; do
    # Clear output file for each thread

    total_patchify=0
    total_linear_embedding=0
    total_positional_embedding=0
    total_vit_block_total=0
    total_classification=0
    total_time_difference=0

    for ((i=1; i<=iterations; i++)); do
        # Set the environment variable for the current number of threads
        export OMP_NUM_THREADS=$threads

        # Run the main executable
        output=$(./main test)

        # Save the output to a file
        echo "Threads: $threads, Iteration: $i, Output: $output" >> output.txt
        echo "--------------------------" >> output.txt

        # # Extract the time difference values from the current iteration's output
        # patchify=$(grep -oE 'Time difference \(patchify\) = ([0-9]+)' <<< "$output" | grep -oE '[0-9]+')
        # linear_embedding=$(grep -oE 'Time difference \(linear embedding\) = ([0-9]+)' <<< "$output" | grep -oE '[0-9]+')
        # positional_embedding=$(grep -oE 'Time difference \(positional embedding\) = ([0-9]+)' <<< "$output" | grep -oE '[0-9]+')
        # vit_block_total=$(grep -oE 'Time difference \(vit block total\) = ([0-9]+)' <<< "$output" | grep -oE '[0-9]+')
        # classification=$(grep -oE 'Time difference \(classification\) = ([0-9]+)' <<< "$output" | grep -oE '[0-9]+')
        # total_diff=$(grep -oE 'Total time difference = ([0-9]+)' <<< "$output" | grep -oE '[0-9]+')

        # # Add the time differences to the totals
        # total_patchify=$((total_patchify + patchify))
        # total_linear_embedding=$((total_linear_embedding + linear_embedding))
        # total_positional_embedding=$((total_positional_embedding + positional_embedding))
        # total_vit_block_total=$((total_vit_block_total + vit_block_total))
        # total_classification=$((total_classification + classification))
        # total_time_difference=$((total_time_difference + total_diff))
    done

    # Calculate the average time differences
    # average_patchify=$(echo "scale=2; $total_patchify / $iterations" | bc)
    # average_linear_embedding=$(echo "scale=2; $total_linear_embedding / $iterations" | bc)
    # average_positional_embedding=$(echo "scale=2; $total_positional_embedding / $iterations" | bc)
    # average_vit_block_total=$(echo "scale=2; $total_vit_block_total / $iterations" | bc)
    # average_classification=$(echo "scale=2; $total_classification / $iterations" | bc)
    # average_time_difference=$(echo "scale=2; $total_time_difference / $iterations" | bc)

    # # Add the average time differences to the array
    # average_times+=("Threads: $threads, Average time difference (patchify): $average_patchify[µs]")
    # average_times+=("Threads: $threads, Average time difference (linear embedding): $average_linear_embedding[µs]")
    # average_times+=("Threads: $threads, Average time difference (positional embedding): $average_positional_embedding[µs]")
    # average_times+=("Threads: $threads, Average time difference (vit block total): $average_vit_block_total[µs]")
    # average_times+=("Threads: $threads, Average time difference (classification): $average_classification[µs]")
    # average_times+=("Threads: $threads, Average total time difference: $average_time_difference[µs]")

    # echo "Average Time Differences:" >> output.txt
    # for time in "${average_times[@]}"; do
    # echo "$time" >> output.txt
    # done
    # echo "============================" >> output.txt
done
