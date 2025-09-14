import random

# --- Configuration ---
N_BITS = 16 # Set the bit-width for the test
NUM_VECTORS = 100 # How many random test vectors to generate
FILENAME = "test_vectors.txt"

# --- Golden Model ---
# This class models the exact behavior of our Verilog counter.
class CounterModel:
    def __init__(self, n_bits):
        self.n_bits = n_bits
        self.max_val = (1 << n_bits) - 1
        self.current_count = 0

    def step(self, control, parallel_in):
        """Calculates the next state based on inputs."""
        # Hold state
        if control == 0b00:
            next_count = self.current_count
        # Count Up
        elif control == 0b01:
            next_count = (self.current_count + 1) & self.max_val
        # Count Down
        elif control == 0b10:
            next_count = (self.current_count - 1) & self.max_val
        # Parallel Load
        elif control == 0b11:
            next_count = parallel_in
        else:
            next_count = self.current_count

        expected_output = self.current_count
        self.current_count = next_count
        return expected_output


def generate_test_vectors():
    """Generates a sequence of test vectors and writes them to a file."""
    model = CounterModel(N_BITS)
    print(f"Generating {NUM_VECTORS} test vectors for an {N_BITS}-bit counter...")

    with open(FILENAME, 'w') as f:
        # Write a header for clarity
        f.write(f"// Test vectors: control[1:0] parallel_in[N-1:0] expected_out[N-1:0]\n")

        # Start with a few directed tests for sanity checks
        # 1. Test Load
        p_in = 42
        f.write(f"{0b11:02b} {p_in:0{N_BITS}b} {model.step(0b11, p_in):0{N_BITS}b}\n")
        # 2. Test Hold
        f.write(f"{0b00:02b} {0:0{N_BITS}b} {model.step(0b00, 0):0{N_BITS}b}\n")
        # 3. Test Count Up
        f.write(f"{0b01:02b} {0:0{N_BITS}b} {model.step(0b01, 0):0{N_BITS}b}\n")
        # 4. Test Count Down
        f.write(f"{0b10:02b} {0:0{N_BITS}b} {model.step(0b10, 0):0{N_BITS}b}\n")

        # Generate randomized test vectors
        for _ in range(NUM_VECTORS - 4):
            control = random.randint(0, 3)
            parallel_in = random.randint(0, (1 << N_BITS) - 1)
            expected_out = model.step(control, parallel_in)

            # Write to file in binary format
            f.write(f"{control:02b} {parallel_in:0{N_BITS}b} {expected_out:0{N_BITS}b}\n")

    print(f"Successfully created '{FILENAME}'")

if __name__ == "__main__":
    generate_test_vectors()