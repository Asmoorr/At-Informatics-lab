#!/bin/bash

# Проверка доступности команды at
if ! command -v at &>/dev/null; then
  echo "Команда 'at' не найдена. Установите её с помощью 'sudo apt install at'."
  exit 1
fi

# Проверка, работает ли служба atd
if ! systemctl is-active --quiet atd; then
  echo "Служба 'atd' не запущена. Запустите её с помощью 'sudo systemctl start atd'."
  exit 1
fi

# Запрос текста напоминания
echo "Введите текст напоминания:"
read -r reminder_text

# Запрос времени выполнения задачи
echo "Введите время для напоминания (например, 'now + 30 minutes' или 'tomorrow at 3pm'):"
read -r time_input

# Проверка, доступна ли команда notify-send
if command -v notify-send &>/dev/null; then
  notification_command="notify-send \"$reminder_text\""
else
  echo "Графические уведомления недоступны. Напоминание будет записано в ~/reminders.log."
  notification_command="echo \"$(date): $reminder_text\" >> ~/reminders.log"
fi

# Создание задания через at
echo "$notification_command" | at "$time_input"

# Проверка успешности
if [[ $? -eq 0 ]]; then
  echo "Напоминание успешно запланировано!"
  echo "Используйте 'atq', чтобы проверить список задач."
else
  echo "Ошибка при создании напоминания."
  exit 1
fi
