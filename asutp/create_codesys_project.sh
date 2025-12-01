#!/bin/bash
# $> ./create_codesys_project.sh
# Создаем структуру проекта для CoDeSys в виде архива (эмуляция .project)

project_name='Reversing_Starter_LAD'

lad_logic='(* Reversing Starter Logic with SR triggers *)

VAR
    Btn_Fwd    : BOOL;   // Кнопка "вперёд"
    Btn_StopF  : BOOL;   // "стоп вперёд"
    Thermo1    : BOOL;   // Термореле 1
    Btn_Rev    : BOOL;   // Кнопка "назад"
    Btn_StopR  : BOOL;   // "стоп назад"
    Thermo2    : BOOL;   // Термореле 2

    KM1        : BOOL;   // Пускатель "вперёд"
    KM2        : BOOL;   // Пускатель "назад"

    FWD_TRIG   : SR;     // Триггер "вперёд"
    REV_TRIG   : SR;     // Триггер "назад"
END_VAR

// Network 1: Forward Control
FWD_TRIG(S := Btn_Fwd AND NOT KM2, R := Btn_StopF OR Thermo1);
KM1 := FWD_TRIG.Q;

// Network 2: Reverse Control
REV_TRIG(S := Btn_Rev AND NOT KM1, R := Btn_StopR OR Thermo2);
KM2 := REV_TRIG.Q;'

echo "${lad_logic}" > "${project_name}.program"
zip "${project_name}.project" "${project_name}.program"

