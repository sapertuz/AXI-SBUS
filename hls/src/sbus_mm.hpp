#ifndef __SBUS_MM__
#define __SBUS_MM__

#include <cstdlib>
#include <stdio.h>
#include <stdint.h>
#include "ap_int.h"

#define divceil(dividend, divisor) ((dividend + (divisor - (divisor > 0 ? 1 : 0))) / divisor)
#define nexteven(number) (number + (number % 2))

constexpr int data_bitwidth =       128;
constexpr int nchannels =           17;
constexpr int channels_bitwidth =   16;
constexpr int memory_size_h =       divceil(nchannels*channels_bitwidth , data_bitwidth);
constexpr int memory_size =         memory_size_h*2;
constexpr int unroll_factor =       nchannels / (data_bitwidth / channels_bitwidth);
constexpr int unroll_size =         data_bitwidth / channels_bitwidth;

typedef ap_uint<data_bitwidth> port_data_type; //  uint64_t
typedef ap_uint<channels_bitwidth> channel_data_type; //  uint16_t

enum states {
    IDLE,
    RX_in,
    RX,
    TX,
    TX_out
};

void sbus_mm(
    volatile port_data_type *data,

    channel_data_type channel0_in,    
    channel_data_type channel1_in,
    channel_data_type channel2_in,
    channel_data_type channel3_in,
    channel_data_type channel4_in,
    channel_data_type channel5_in,
    channel_data_type channel6_in,
    channel_data_type channel7_in,
    channel_data_type channel8_in,
    channel_data_type channel9_in,
    channel_data_type channel10_in,
    channel_data_type channel11_in,
    channel_data_type channel12_in,
    channel_data_type channel13_in,
    channel_data_type channel14_in,
    channel_data_type channel15_in,
    channel_data_type channel16_in,

    channel_data_type &channel0_out,
    channel_data_type &channel1_out,
    channel_data_type &channel2_out,
    channel_data_type &channel3_out,
    channel_data_type &channel4_out,
    channel_data_type &channel5_out,
    channel_data_type &channel6_out,
    channel_data_type &channel7_out,
    channel_data_type &channel8_out,
    channel_data_type &channel9_out,
    channel_data_type &channel10_out,
    channel_data_type &channel11_out,
    channel_data_type &channel12_out,
    channel_data_type &channel13_out,
    channel_data_type &channel14_out,
    channel_data_type &channel15_out,
    channel_data_type &channel16_out
);

#endif