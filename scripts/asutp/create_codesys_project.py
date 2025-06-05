from zipfile import ZipFile
from pathlib import Path

# Создаем структуру проекта для CoDeSys в виде архива (эмуляция .project)
project_name = "Reversing_Starter_LAD"
project_dir = Path(".") / project_name
project_dir.mkdir(exist_ok=True)

# Создаем файл с переменными и логикой в ST формате (в Codesys .project XML, но мы эмулируем)
lad_logic = """
(* Reversing Starter Logic with SR triggers *)

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
KM2 := REV_TRIG.Q;
"""

lad_file = project_dir / "LAD_Reversing_Starter.program"
lad_file.write_text(lad_logic)

# Упакуем в zip-архив как .project (эмуляция)
zip_path = Path(".") / f"{project_name}.zip"
with ZipFile(zip_path, 'w') as zipf:
    zipf.write(lad_file, arcname=lad_file.name)

zip_path.rename(zip_path.with_suffix(".project"))
zip_path = zip_path.with_suffix(".project")
zip_path

