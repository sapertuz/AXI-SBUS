// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2023.2 (64-bit)
// Tool Version Limit: 2023.10
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xsbus_mm.h"

extern XSbus_mm_Config XSbus_mm_ConfigTable[];

#ifdef SDT
XSbus_mm_Config *XSbus_mm_LookupConfig(UINTPTR BaseAddress) {
	XSbus_mm_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XSbus_mm_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XSbus_mm_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XSbus_mm_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XSbus_mm_Initialize(XSbus_mm *InstancePtr, UINTPTR BaseAddress) {
	XSbus_mm_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XSbus_mm_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XSbus_mm_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XSbus_mm_Config *XSbus_mm_LookupConfig(u16 DeviceId) {
	XSbus_mm_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XSBUS_MM_NUM_INSTANCES; Index++) {
		if (XSbus_mm_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XSbus_mm_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XSbus_mm_Initialize(XSbus_mm *InstancePtr, u16 DeviceId) {
	XSbus_mm_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XSbus_mm_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XSbus_mm_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

