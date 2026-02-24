package fir_pkg;

    // ===============================
    // FIR Configuration Parameters
    // ===============================

    parameter int TAPS      = 32;   // Number of FIR taps
    parameter int DATA_W    = 16;   // Input data width
    parameter int COEFF_W   = 16;   // Coefficient width
    parameter int PROD_W    = DATA_W + COEFF_W;   // Multiplier output width
    parameter int ACC_W     = 40;   // Accumulator width (extra guard bits)

    // ===============================
    // Derived Parameters
    // ===============================

    parameter int ADDR_W    = $clog2(TAPS);

endpackage : fir_pkg
