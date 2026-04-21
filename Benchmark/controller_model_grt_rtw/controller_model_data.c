/*
 * controller_model_data.c
 *
 * Code generation for model "controller_model".
 *
 * Model version              : 1.16
 * Simulink Coder version : 8.11 (R2016b) 25-Aug-2016
 * C source code generated on : Sat Nov 09 12:07:27 2024
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Specified
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "controller_model.h"
#include "controller_model_private.h"

/* Block parameters (auto storage) */
P_controller_model_T controller_model_P = {
  3.814697265625E-6,                   /* Variable: quantize_int
                                        * Referenced by:
                                        *   '<S1>/Quantizer'
                                        *   '<S3>/Quantizer'
                                        */
  -3.8,                                /* Variable: sat_limit_lower
                                        * Referenced by:
                                        *   '<S1>/Saturation'
                                        *   '<S3>/Saturation'
                                        */
  3.8,                                 /* Variable: sat_limit_upper
                                        * Referenced by:
                                        *   '<S1>/Saturation'
                                        *   '<S3>/Saturation'
                                        */
  0.0,                                 /* Mask Parameter: DiscreteDerivative_ICPrevScaled
                                        * Referenced by: '<S4>/UD'
                                        */
  0.0,                                 /* Mask Parameter: DiscreteDerivative1_ICPrevScale
                                        * Referenced by: '<S5>/UD'
                                        */
  4096.0,                              /* Computed Parameter: TSamp_WtEt
                                        * Referenced by: '<S4>/TSamp'
                                        */
  4096.0                               /* Computed Parameter: TSamp_WtEt_b
                                        * Referenced by: '<S5>/TSamp'
                                        */
};
