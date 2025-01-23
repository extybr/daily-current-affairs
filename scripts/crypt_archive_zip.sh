#!/bin/bash
# $> ./crypt_archive_zip.sh myfile1.txt myfile2.txt
# Архивируем файлы и шифруем архив

function cryptArchiveZip {
  # Архивируем файлы и шифруем архив myarchive.zip
  zip -re myarchive.zip "$@"
}

cryptArchiveZip "$@"

