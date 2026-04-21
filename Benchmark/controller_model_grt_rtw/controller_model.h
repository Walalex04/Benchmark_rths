/*
 * controller_model.h
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

#ifndef RTW_HEADER_controller_model_h_
#define RTW_HEADER_controller_model_h_
#include <math.h>
#include <string.h>
#include <float.h>
#include <stddef.h>
#ifndef controller_model_COMMON_INCLUDES_
# define controller_model_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#include "rt_logging.h"
#endif                                 /* controller_model_COMMON_INCLUDES_ */

#include "controller_model_types.h"

/* Shared type includes */
#include "multiword_types.h"
#include "rt_nonfinite.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetFinalTime
# define rtmGetFinalTime(rtm)          ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetRTWLogInfo
# define rtmGetRTWLogInfo(rtm)         ((rtm)->rtwLogInfo)
#endif

#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
# define rtmGetStopRequested(rtm)      ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
# define rtmSetStopRequested(rtm, val) ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
# define rtmGetStopRequestedPtr(rtm)   (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
# define rtmGetT(rtm)                  ((rtm)->Timing.taskTime0)
#endif

#ifndef rtmGetTFinal
# define rtmGetTFinal(rtm)             ((rtm)->Timing.tFinal)
#endif

/* Block states (auto storage) for system '<Root>' */
typedef struct {
  real_T UD_DSTATE;                    /* '<S4>/UD' */
  real_T UD_DSTATE_a;                  /* '<S5>/UD' */
} DW_controller_model_T;

/* External inputs (root inport signals with auto storage) */
typedef struct {
  real_T y_n;                          /* '<Root>/y_n' */
  real_T x_m;                          /* '<Root>/x_m' */
} ExtU_controller_model_T;

/* External outputs (root outports fed by signals with auto storage) */
typedef struct {
  real_T y_gc;                         /* '<Root>/y_gc' */
} ExtY_controller_model_T;

/* Parameters (auto storage) */
struct P_controller_model_T_ {
  real_T quantize_int;                 /* Variable: quantize_int
                                        * Referenced by:
                                        *   '<S1>/Quantizer'
                                        *   '<S3>/Quantizer'
                                        */
  real_T sat_limit_lower;              /* Variable: sat_limit_lower
                                        * Referenced by:
                                        *   '<S1>/Saturation'
                                        *   '<S3>/Saturation'
                                        */
  real_T sat_limit_upper;              /* Variable: sat_limit_upper
                                        * Referenced by:
                                        *   '<S1>/Saturation'
                                        *   '<S3>/Saturation'
                                        */
  real_T DiscreteDerivative_ICPrevScaled;/* Mask Parameter: DiscreteDerivative_ICPrevScaled
                                          * Referenced by: '<S4>/UD'
                                          */
  real_T DiscreteDerivative1_ICPrevScale;/* Mask Parameter: DiscreteDerivative1_ICPrevScale
                                          * Referenced by: '<S5>/UD'
                                          */
  real_T TSamp_WtEt;                   /* Computed Parameter: TSamp_WtEt
                                        * Referenced by: '<S4>/TSamp'
                                        */
  real_T TSamp_WtEt_b;                 /* Computed Parameter: TSamp_WtEt_b
                                        * Referenced by: '<S5>/TSamp'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_controller_model_T {
  const char_T *errorStatus;
  RTWLogInfo *rtwLogInfo;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    uint32_T clockTickH0;
    time_T stepSize0;
    time_T tFinal;
    boolean_T stopRequestedFlag;
  } Timing;
};

/* Block parameters (auto storage) */
extern P_controller_model_T controller_model_P;

/* Block states (auto storage) */
extern DW_controller_model_T controller_model_DW;

/* External inputs (root inport signals with auto storage) */
extern ExtU_controller_model_T controller_model_U;

/* External outputs (root outports fed by signals with auto storage) */
extern ExtY_controller_model_T controller_model_Y;

/* Model entry point functions */
extern void controller_model_initialize(void);
extern void controller_model_step(void);
extern void controller_model_terminate(void);

/* Real-time Model object */
extern RT_MODEL_controller_model_T *const controller_model_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'controller_model'
 * '<S1>'   : 'controller_model/A//D Converter'
 * '<S2>'   : 'controller_model/A//D Converter1'
 * '<S3>'   : 'controller_model/D//A Converter'
 * '<S4>'   : 'controller_model/Discrete Derivative'
 * '<S5>'   : 'controller_model/Discrete Derivative1'
 * '<S6>'   : 'controller_model/Discrete Derivative2'
 * '<S7>'   : 'controller_model/Discrete Derivative3'
 * '<S8>'   : 'controller_model/Subsystem'
 * '<S9>'   : 'controller_model/Subsystem1'
 */
#endif                                 /* RTW_HEADER_controller_model_h_ */
