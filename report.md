# Отчёт по лабораторной работе №X 

## Реализация  

```bash
#!/bin/bash
```
Указываем путь к bash-интерпретатору, используя shebang.  

### Шаг 1. Проверка команды `at` и службы `atd`

```bash
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
```
Скрипт проверяет, доступна ли команда `at` для планирования задач и запущена ли служба `atd`. При отсутствии или неактивности выдает сообщение об ошибке и завершает работу.  
![image](https://github.com/user-attachments/assets/d9fadfa5-cf01-4dae-a993-5ea87c7df35b)


### Шаг 2. Запрос текста напоминания  

```bash
# Шаг 1. Запрос текста напоминания
echo "Введите текст напоминания:"
read -r reminder_text
```
Запрашивается текст, который будет отправлен пользователю в качестве напоминания.  

### Шаг 3. Запрос времени выполнения задачи  

```bash
# Шаг 2. Запрос времени выполнения задачи
echo "Введите время для напоминания (например, 'now + 30 minutes' или 'tomorrow at 3pm'):"
read -r time_input
```
Пользователь вводит время, в которое напоминание должно сработать. Принимается формат, совместимый с командой `at`.  
![image](https://github.com/user-attachments/assets/d97719d5-d65d-4581-9847-702f452bfcfa)


### Шаг 4. Учет доступности `notify-send`  

```bash
# Шаг 3. Проверка, доступна ли команда notify-send
if command -v notify-send &>/dev/null; then
  notification_command="notify-send \"$reminder_text\""
else
  echo "Графические уведомления недоступны. Напоминание будет записано в ~/reminders.log."
  notification_command="echo \"$(date): $reminder_text\" >> ~/reminders.log"
fi
```
Проверяется, доступна ли команда `notify-send`. Если да, будет отправлено графическое уведомление. Если нет, напоминание записывается в лог-файл `~/reminders.log`.  

### Шаг 5. Создание задачи через `at`  

```bash
# Шаг 4. Создание задания через at
echo "$notification_command" | at "$time_input"

# Шаг 5. Проверка успешности
if [[ $? -eq 0 ]]; then
  echo "Напоминание успешно запланировано!"
  echo "Используйте 'atq', чтобы проверить список задач."
else
  echo "Ошибка при создании напоминания."
  exit 1
fi
```
Команда передается в `at`, чтобы сработать в указанное пользователем время. Если задача успешно создана, выводится сообщение о планировании. В противном случае — ошибка.  
![image](https://github.com/user-attachments/assets/d908d1a0-fcd0-4aa6-a438-e919863d3166)


## Полный код программы  

```bash
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

# Шаг 1. Запрос текста напоминания
echo "Введите текст напоминания:"
read -r reminder_text

# Шаг 2. Запрос времени выполнения задачи
echo "Введите время для напоминания (например, 'now + 30 minutes' или 'tomorrow at 3pm'):"
read -r time_input

# Шаг 3. Проверка, доступна ли команда notify-send
if command -v notify-send &>/dev/null; then
  notification_command="notify-send \"$reminder_text\""
else
  echo "Графические уведомления недоступны. Напоминание будет записано в ~/reminders.log."
  notification_command="echo \"$(date): $reminder_text\" >> ~/reminders.log"
fi

# Шаг 4. Создание задания через at
echo "$notification_command" | at "$time_input"

# Шаг 5. Проверка успешности
if [[ $? -eq 0 ]]; then
  echo "Напоминание успешно запланировано!"
  echo "Используйте 'atq', чтобы проверить список задач."
else
  echo "Ошибка при создании напоминания."
  exit 1
fi
```

## Примеры использования  

1. **Запуск:**  
   ```bash
   ./reminder.sh
   ```  
   > **Скриншот:** консоль с примером запуска и ввода данных.  

2. **Проверка запланированных задач:**  
   ```bash
   atq
   ```  
   > **Скриншот:** список задач, запланированных командой `at`.  

3. **Результат:**  
   - Если доступно `notify-send`, всплывает уведомление.  
     > **Скриншот:** пример графического уведомления.  
   - Если уведомления недоступны, запись добавляется в `~/reminders.log`.  
     > **Скриншот:** содержимое файла `~/reminders.log`.  
