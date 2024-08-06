#include "sbus_mm.hpp"

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
) {

#pragma HLS INTERFACE m_axi port=data depth=memory_size
#pragma HLS bind_storage variable=data type=RAM_1P impl=LUTRAM
#pragma HLS INTERFACE s_axilite port=return

#pragma HLS INTERFACE ap_none port=channel0_in
#pragma HLS INTERFACE ap_none port=channel1_in
#pragma HLS INTERFACE ap_none port=channel2_in
#pragma HLS INTERFACE ap_none port=channel3_in
#pragma HLS INTERFACE ap_none port=channel4_in
#pragma HLS INTERFACE ap_none port=channel5_in
#pragma HLS INTERFACE ap_none port=channel6_in
#pragma HLS INTERFACE ap_none port=channel7_in
#pragma HLS INTERFACE ap_none port=channel8_in
#pragma HLS INTERFACE ap_none port=channel9_in
#pragma HLS INTERFACE ap_none port=channel10_in
#pragma HLS INTERFACE ap_none port=channel11_in
#pragma HLS INTERFACE ap_none port=channel12_in
#pragma HLS INTERFACE ap_none port=channel13_in
#pragma HLS INTERFACE ap_none port=channel14_in
#pragma HLS INTERFACE ap_none port=channel15_in
#pragma HLS INTERFACE ap_none port=channel16_in
#pragma HLS INTERFACE ap_none port=channel0_out
#pragma HLS INTERFACE ap_none port=channel1_out
#pragma HLS INTERFACE ap_none port=channel2_out
#pragma HLS INTERFACE ap_none port=channel3_out
#pragma HLS INTERFACE ap_none port=channel4_out
#pragma HLS INTERFACE ap_none port=channel5_out
#pragma HLS INTERFACE ap_none port=channel6_out
#pragma HLS INTERFACE ap_none port=channel7_out
#pragma HLS INTERFACE ap_none port=channel8_out
#pragma HLS INTERFACE ap_none port=channel9_out
#pragma HLS INTERFACE ap_none port=channel10_out
#pragma HLS INTERFACE ap_none port=channel11_out
#pragma HLS INTERFACE ap_none port=channel12_out
#pragma HLS INTERFACE ap_none port=channel13_out
#pragma HLS INTERFACE ap_none port=channel14_out
#pragma HLS INTERFACE ap_none port=channel15_out
#pragma HLS INTERFACE ap_none port=channel16_out

    volatile int state = IDLE;
    volatile channel_data_type buff_in[nchannels] = {0};
    volatile channel_data_type buff_out[nchannels] = {0};
#pragma HLS array_partition variable=buff_in type=complete
#pragma HLS array_partition variable=buff_out type=complete
    // channel_data_type *buff = (channel_data_type *)data;

    volatile bool exit = false;
    int i = 0;

    while (!exit){
    switch (state)
        case IDLE:{
            state = RX_in;
            break;

        case RX_in:
            buff_in[0] = channel0_in;
            buff_in[1] = channel1_in;
            buff_in[2] = channel2_in;
            buff_in[3] = channel3_in;
            buff_in[4] = channel4_in;
            buff_in[5] = channel5_in;
            buff_in[6] = channel6_in;
            buff_in[7] = channel7_in;
            buff_in[8] = channel8_in;
            buff_in[9] = channel9_in;
            buff_in[10] = channel10_in;
            buff_in[11] = channel11_in;
            buff_in[12] = channel12_in;
            buff_in[13] = channel13_in;
            buff_in[14] = channel14_in;
            buff_in[15] = channel15_in;
            buff_in[16] = channel16_in;
            state = RX;
            break;

        case RX:{
            i = 0;
            rx_loop: for (i = 0; i < memory_size_h; i++){
#pragma HLS pipeline II=1
                port_data_type data_tmp = -1;
                rx_store_loop: for (int j = unroll_size-1; j >= 0; j--){
#pragma HLS unroll
                    int ii = i*unroll_size + j;
                    if (ii < nchannels)
                        data_tmp = (data_tmp << channels_bitwidth) | ((channel_data_type)buff_in[ii] & 0xFFFF);
                }
                data[i] = data_tmp;        
            }
            if (i == memory_size_h)
                state = TX;
            break;
        }

        case TX:
            i = 0;
            tx_loop: for (i = 0; i < memory_size_h; i++){            
#pragma HLS pipeline II=1
                port_data_type data_tmp = data[memory_size_h + i];
                tx_store_loop: for (int j = 0; j < unroll_size; j++){
#pragma HLS unroll
                    int ii = i*unroll_size + j;
                    if (ii < nchannels)
                        buff_out[ii] = ((data_tmp >> channels_bitwidth*j) & 0xFFFF);
                }
            }
            if (i == memory_size_h)
                state = TX_out;
            break;

        case TX_out:
            channel0_out = buff_out[0];
            channel1_out = buff_out[1];
            channel2_out = buff_out[2];
            channel3_out = buff_out[3];
            channel4_out = buff_out[4];
            channel5_out = buff_out[5];
            channel6_out = buff_out[6];
            channel7_out = buff_out[7];
            channel8_out = buff_out[8];
            channel9_out = buff_out[9];
            channel10_out = buff_out[10];
            channel11_out = buff_out[11];
            channel12_out = buff_out[12];
            channel13_out = buff_out[13];
            channel14_out = buff_out[14];
            channel15_out = buff_out[15];
            channel16_out = buff_out[16];
            state = IDLE;
            exit = true;
            break;
        
        default:
            state = IDLE;
            break;
        }
    }

}