#include <cstdlib>
#include <stdio.h>
#include <stdint.h>
#include <iomanip> // for setw
#include "sbus_mm.hpp"

void printMem(channel_data_type arr[], int n_size, int n_cols) {
  // Check if the array size is divisible by the number of columns
  if (n_size % n_cols != 0) {
    std::cerr << "Error: Array size must be divisible by the number of columns." << std::endl;
    return;
  }

  // Calculate the number of rows
  int n_rows = n_size / n_cols;

  // Print each row of the matrix
  for (int i = 0; i < n_rows; i++) {
    // Print row address (optional)
    // You can uncomment this line if you want to print the address of each row
    std::cout << std::hex << i * n_cols * 2 << " | ";  // Assuming uint16_t size is 2 bytes

    // Print elements in each column with fixed width and zero padding
    for (int j = 0; j < n_cols; j++) {
      std::cout << std::setw(4) << std::hex << std::setfill('0') <<  arr[i * n_cols + j] << ", ";
    }
    std::cout << std::endl;
  }
}

int main() {
    port_data_type data[memory_size];
    for (int i = 0; i < memory_size; i++)
        data[i] = 0;

    channel_data_type *data_print = (channel_data_type *)data;
    std::srand(1234);
    for (int i = memory_size_h*unroll_size; i < memory_size_h*unroll_size+nchannels; ++i)  
        data_print[i] = (channel_data_type)(std::rand() & 0xFFFF);

    // Initialize input channels
    channel_data_type input_channels[nchannels] = {
        0x0001, 0x0002, 0x0003, 0x0004,
        0x0005, 0x0006, 0x0007, 0x0008,
        0x0009, 0x000A, 0x000B, 0x000C,
        0x000D, 0x000E, 0x000F, 0x0010,
        0x0011
    };

    // Variables to hold output channels
    channel_data_type output_channels[nchannels];
    for (int i = 0; i < nchannels; i++)
        output_channels[i] = 0;
    

    // Call the HLS function
    sbus_mm(
        data,
        input_channels[0], input_channels[1], input_channels[2], input_channels[3],
        input_channels[4], input_channels[5], input_channels[6], input_channels[7],
        input_channels[8], input_channels[9], input_channels[10], input_channels[11],
        input_channels[12], input_channels[13], input_channels[14], input_channels[15],
        input_channels[16],
        output_channels[0], output_channels[1], output_channels[2], output_channels[3],
        output_channels[4], output_channels[5], output_channels[6], output_channels[7],
        output_channels[8], output_channels[9], output_channels[10], output_channels[11],
        output_channels[12], output_channels[13], output_channels[14], output_channels[15],
        output_channels[16]
    );

    // Print the results
    printMem(data_print, memory_size*data_bitwidth/channels_bitwidth, unroll_size);

    for (int i = 0; i < nchannels; ++i) {
        std::cout << "Output channel " << i << ": " << std::hex << output_channels[i] << std::endl;
    }

    return 0;
}