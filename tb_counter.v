`timescale 1ns / 1ps

module tb_counter;

    // Parameters
    localparam N = 16;
    localparam CLK_PERIOD = 10; // 10 ns clock period -> 100 MHz

    // Testbench signals
    reg clk;
    reg rst_n;
    reg [1:0] control;
    reg [N-1:0] parallel_in;
    wire [N-1:0] count_out;
    
    // Signals for file reading and checking
    integer file_handle;
    integer scan_status; // We will reuse this for $fgets
    reg [N-1:0] expected_out;
    integer error_count = 0;
    integer vector_count = 0;
    reg [1023:0] dummy_line;

    // Instantiate the Device Under Test (DUT)
    counter #(
        .N(N)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .control(control),
        .parallel_in(parallel_in),
        .count_out(count_out)
    );

    // Clock generator
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Main simulation sequence
    initial begin
        // 1. Initialize signals and open vector file
        clk = 0;
        rst_n = 1;
        control = 2'b00;
        parallel_in = {N{1'b0}};

        file_handle = $fopen("test_vectors.txt", "r");
        if (file_handle == 0) begin
            $display("ERROR: Could not open test_vectors.txt");
            $finish;
        end

        // 2. Dump waves for GTKWave
        $dumpfile("counter_wave.vcd");
        $dumpvars(0, tb_counter);

        // 3. Apply reset
        rst_n = 0;
        #(CLK_PERIOD * 2);
        rst_n = 1;
        #(CLK_PERIOD);
        
        // *** THE FIX: Assign the return value of the $fgets function ***
        // $fgets returns the number of characters read, which we store in scan_status.
        scan_status = $fgets(dummy_line, file_handle);

        // 4. Main test loop
        $display("------ Starting Simulation ------");
        while (!$feof(file_handle)) begin
            scan_status = $fscanf(file_handle, "%b %b %b\n", control, parallel_in, expected_out);

            // Wait for the next clock edge
            @(posedge clk);
            
            #1; 
            if (count_out !== expected_out) begin
                $display("ERROR @ time %0t: Vector %0d", $time, vector_count);
                $display("  Control=%b, P_in=%b", control, parallel_in);
                $display("  Expected=%d, Got=%d", expected_out, count_out);
                error_count = error_count + 1;
            end
            vector_count = vector_count + 1;
        end

        // 5. Final report
        #(CLK_PERIOD);
        if (error_count == 0) begin
            $display("------ Simulation SUCCESS: All %0d tests passed! ------", vector_count);
        end else begin
            $display("------ Simulation FAILED: %0d errors out of %0d tests. ------", error_count, vector_count);
        end

        $fclose(file_handle);
        $finish;
    end

endmodule