/*
 * controller_model.c
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

/* Block states (auto storage) */
DW_controller_model_T controller_model_DW;

/* External inputs (root inport signals with auto storage) */
ExtU_controller_model_T controller_model_U;

/* External outputs (root outports fed by signals with auto storage) */
ExtY_controller_model_T controller_model_Y;

/* Real-time model */
RT_MODEL_controller_model_T controller_model_M_;
RT_MODEL_controller_model_T *const controller_model_M = &controller_model_M_;
real_T rt_roundd_snf(real_T u)
{
  real_T y;
  if (fabs(u) < 4.503599627370496E+15) {
    if (u >= 0.5) {
      y = floor(u + 0.5);
    } else if (u > -0.5) {
      y = u * 0.0;
    } else {
      y = ceil(u - 0.5);
    }
  } else {
    y = u;
  }

  return y;
}

/* Model step function */
void controller_model_step(void)
{
  real_T rtb_Quantizer;
  real_T rtb_TSamp;
  real_T rtb_TSamp_g;

  /* Saturate: '<S1>/Saturation' incorporates:
   *  Inport: '<Root>/y_n'
   */
  if (controller_model_U.y_n > controller_model_P.sat_limit_upper) {
    rtb_TSamp = controller_model_P.sat_limit_upper;
  } else if (controller_model_U.y_n < controller_model_P.sat_limit_lower) {
    rtb_TSamp = controller_model_P.sat_limit_lower;
  } else {
    rtb_TSamp = controller_model_U.y_n;
  }

  /* End of Saturate: '<S1>/Saturation' */

  /* Quantizer: '<S1>/Quantizer' */
  rtb_Quantizer = rt_roundd_snf(rtb_TSamp / controller_model_P.quantize_int) *
    controller_model_P.quantize_int;

  /* SampleTimeMath: '<S4>/TSamp'
   *
   * About '<S4>/TSamp':
   *  y = u * K where K = 1 / ( w * Ts )
   */
  rtb_TSamp = rtb_Quantizer * controller_model_P.TSamp_WtEt;

  /* SampleTimeMath: '<S5>/TSamp'
   *
   * About '<S5>/TSamp':
   *  y = u * K where K = 1 / ( w * Ts )
   */
  rtb_TSamp_g = rtb_Quantizer * controller_model_P.TSamp_WtEt_b;

  /* Quantizer: '<S3>/Quantizer' incorporates:
   *  Product: '<S8>/Product'
   *  Product: '<S8>/Product1'
   *  Product: '<S8>/Product2'
   *  Sum: '<S4>/Diff'
   *  Sum: '<S5>/Diff'
   *  Sum: '<S8>/Add'
   *  UnitDelay: '<S4>/UD'
   *  UnitDelay: '<S5>/UD'
   */
  rtb_Quantizer = rt_roundd_snf((((rtb_TSamp - controller_model_DW.UD_DSTATE) *
    0.0 + rtb_Quantizer * 0.0) + (rtb_TSamp_g - controller_model_DW.UD_DSTATE_a)
    * 0.0) / controller_model_P.quantize_int) * controller_model_P.quantize_int;

  /* Saturate: '<S3>/Saturation' */
  if (rtb_Quantizer > controller_model_P.sat_limit_upper) {
    /* Outport: '<Root>/y_gc' */
    controller_model_Y.y_gc = controller_model_P.sat_limit_upper;
  } else if (rtb_Quantizer < controller_model_P.sat_limit_lower) {
    /* Outport: '<Root>/y_gc' */
    controller_model_Y.y_gc = controller_model_P.sat_limit_lower;
  } else {
    /* Outport: '<Root>/y_gc' */
    controller_model_Y.y_gc = rtb_Quantizer;
  }

  /* End of Saturate: '<S3>/Saturation' */

  /* Update for UnitDelay: '<S4>/UD' */
  controller_model_DW.UD_DSTATE = rtb_TSamp;

  /* Update for UnitDelay: '<S5>/UD' */
  controller_model_DW.UD_DSTATE_a = rtb_TSamp_g;

  /* Matfile logging */
  rt_UpdateTXYLogVars(controller_model_M->rtwLogInfo,
                      (&controller_model_M->Timing.taskTime0));

  /* signal main to stop simulation */
  {                                    /* Sample time: [0.000244140625s, 0.0s] */
    if ((rtmGetTFinal(controller_model_M)!=-1) &&
        !((rtmGetTFinal(controller_model_M)-controller_model_M->Timing.taskTime0)
          > controller_model_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(controller_model_M, "Simulation finished");
    }
  }

  /* Update absolute time for base rate */
  /* The "clockTick0" counts the number of times the code of this task has
   * been executed. The absolute time is the multiplication of "clockTick0"
   * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
   * overflow during the application lifespan selected.
   * Timer of this task consists of two 32 bit unsigned integers.
   * The two integers represent the low bits Timing.clockTick0 and the high bits
   * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
   */
  if (!(++controller_model_M->Timing.clockTick0)) {
    ++controller_model_M->Timing.clockTickH0;
  }

  controller_model_M->Timing.taskTime0 = controller_model_M->Timing.clockTick0 *
    controller_model_M->Timing.stepSize0 +
    controller_model_M->Timing.clockTickH0 *
    controller_model_M->Timing.stepSize0 * 4294967296.0;
}

/* Model initialize function */
void controller_model_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)controller_model_M, 0,
                sizeof(RT_MODEL_controller_model_T));
  rtmSetTFinal(controller_model_M, 41.179931640625);
  controller_model_M->Timing.stepSize0 = 0.000244140625;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    rt_DataLoggingInfo.loggingInterval = NULL;
    controller_model_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(controller_model_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(controller_model_M->rtwLogInfo, (NULL));
    rtliSetLogT(controller_model_M->rtwLogInfo, "tout");
    rtliSetLogX(controller_model_M->rtwLogInfo, "");
    rtliSetLogXFinal(controller_model_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(controller_model_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(controller_model_M->rtwLogInfo, 2);
    rtliSetLogMaxRows(controller_model_M->rtwLogInfo, 0);
    rtliSetLogDecimation(controller_model_M->rtwLogInfo, 1);

    /*
     * Set pointers to the data and signal info for each output
     */
    {
      static void * rt_LoggedOutputSignalPtrs[] = {
        &controller_model_Y.y_gc
      };

      rtliSetLogYSignalPtrs(controller_model_M->rtwLogInfo, ((LogSignalPtrsType)
        rt_LoggedOutputSignalPtrs));
    }

    {
      static int_T rt_LoggedOutputWidths[] = {
        1
      };

      static int_T rt_LoggedOutputNumDimensions[] = {
        1
      };

      static int_T rt_LoggedOutputDimensions[] = {
        1
      };

      static boolean_T rt_LoggedOutputIsVarDims[] = {
        0
      };

      static void* rt_LoggedCurrentSignalDimensions[] = {
        (NULL)
      };

      static int_T rt_LoggedCurrentSignalDimensionsSize[] = {
        4
      };

      static BuiltInDTypeId rt_LoggedOutputDataTypeIds[] = {
        SS_DOUBLE
      };

      static int_T rt_LoggedOutputComplexSignals[] = {
        0
      };

      static const char_T *rt_LoggedOutputLabels[] = {
        "" };

      static const char_T *rt_LoggedOutputBlockNames[] = {
        "controller_model/y_gc" };

      static RTWLogDataTypeConvert rt_RTWLogDataTypeConvert[] = {
        { 0, SS_DOUBLE, SS_DOUBLE, 0, 0, 0, 1.0, 0, 0.0 }
      };

      static RTWLogSignalInfo rt_LoggedOutputSignalInfo[] = {
        {
          1,
          rt_LoggedOutputWidths,
          rt_LoggedOutputNumDimensions,
          rt_LoggedOutputDimensions,
          rt_LoggedOutputIsVarDims,
          rt_LoggedCurrentSignalDimensions,
          rt_LoggedCurrentSignalDimensionsSize,
          rt_LoggedOutputDataTypeIds,
          rt_LoggedOutputComplexSignals,
          (NULL),

          { rt_LoggedOutputLabels },
          (NULL),
          (NULL),
          (NULL),

          { rt_LoggedOutputBlockNames },

          { (NULL) },
          (NULL),
          rt_RTWLogDataTypeConvert
        }
      };

      rtliSetLogYSignalInfo(controller_model_M->rtwLogInfo,
                            rt_LoggedOutputSignalInfo);

      /* set currSigDims field */
      rt_LoggedCurrentSignalDimensions[0] = &rt_LoggedOutputWidths[0];
    }

    rtliSetLogY(controller_model_M->rtwLogInfo, "yout");
  }

  /* states (dwork) */
  (void) memset((void *)&controller_model_DW, 0,
                sizeof(DW_controller_model_T));

  /* external inputs */
  (void)memset((void *)&controller_model_U, 0, sizeof(ExtU_controller_model_T));

  /* external outputs */
  controller_model_Y.y_gc = 0.0;

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(controller_model_M->rtwLogInfo, 0.0,
    rtmGetTFinal(controller_model_M), controller_model_M->Timing.stepSize0,
    (&rtmGetErrorStatus(controller_model_M)));

  /* InitializeConditions for UnitDelay: '<S4>/UD' */
  controller_model_DW.UD_DSTATE =
    controller_model_P.DiscreteDerivative_ICPrevScaled;

  /* InitializeConditions for UnitDelay: '<S5>/UD' */
  controller_model_DW.UD_DSTATE_a =
    controller_model_P.DiscreteDerivative1_ICPrevScale;
}

/* Model terminate function */
void controller_model_terminate(void)
{
  /* (no terminate code required) */
}
