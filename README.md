# Лабораторная работа: Автоматизированное напоминание с использованием планировщика задач `at`

## Разминка (в отчет не включать)

Перед началом выполнения задания изучите работу команды `at`. Эта команда позволяет запланировать выполнение задачи в указанное время.

### Шаги разминки:

1. **Убедитесь, что пакет `at` установлен в системе:**
   ```bash
   sudo apt install at
   ```

2. **Запустите сервис `atd`, если он не работает:**
   ```bash
   sudo systemctl start atd
   ```

3. **Создайте простое задание с использованием `at`:**
   ```bash
   echo "echo 'Напоминание: сделать перерыв!' >> ~/reminder.txt" | at now + 1 minute
   ```
   Проверьте, появился ли файл с напоминанием через минуту:
   ```bash
   cat ~/reminder.txt
   ```

4. **Просмотрите список задач:**
   ```bash
   atq
   ```

5. **Удалите запланированное задание:**
   ```bash
   atrm <номер задачи>
   ```
   Номер задачи можно найти в выводе команды `atq`.

---

## Задание лабораторной работы

### Цель работы
Познакомиться с командой `at` для планирования задач, научиться создавать и настраивать скрипты для автоматизации напоминаний.

---

### Задание

Необходимо написать Bash-скрипт, который:

1. Запрашивает у пользователя текст напоминания, которое он хочет создать.  
   Это сообщение будет показано в указанное время.

2. Предлагает пользователю указать время, когда напоминание должно сработать:  
   - в формате `now + N minutes/hours` (например, "через 30 минут");  
   - в формате даты и времени (например, "tomorrow at 9am").  

3. Проверяет, доступна ли команда `notify-send` для отправки графического уведомления. Если команда недоступна, записывает напоминание в текстовый файл `~/reminders.log`.  

4. Создает задачу с помощью команды `at`, чтобы напоминание сработало в указанное пользователем время.  

---

### Требования к реализации:

1. **Запрос текста напоминания:**  
   - При запуске скрипта пользователь вводит сообщение, которое он хочет получить как напоминание.  

2. **Выбор времени:**  
   - Скрипт предлагает пользователю указать, когда напоминание должно сработать. Введите время в формате:
     - `now + N minutes` — для задач через некоторое время.  
     - `tomorrow at 9am` — для задач на следующий день.  
     - Конкретная дата и время (например, `2024-12-26 15:30`).  

3. **Уведомление:**  
   - Если доступна команда `notify-send`, скрипт показывает сообщение в виде всплывающего уведомления.  
   - Если `notify-send` недоступен, напоминание записывается в файл `~/reminders.log`.  

4. **Запланированная задача:**  
   - С помощью команды `at` скрипт добавляет задачу в очередь выполнения.  
   - Если указана неверная дата или время, скрипт сообщает об ошибке и предлагает повторить ввод.  

5. **Проверка установленных задач:**  
   - Скрипт подсказывает, как проверить список задач (`atq`) или удалить запланированное напоминание (`atrm`).

---

### Пример взаимодействия

1. **Запуск скрипта:**
   ```bash
   ./reminder.sh
   ```

2. **Диалог с пользователем:**
   ```
   Введите текст напоминания:
   Завершить отчет по проекту

   Укажите время напоминания (например, 'now + 30 minutes' или 'tomorrow at 9am'):
   now + 2 hours

   Напоминание успешно запланировано! Используйте 'atq', чтобы проверить очередь задач.
   ```

3. **Через 2 часа:**  
   - Если доступно `notify-send`, на экране появится сообщение:
     ```
     Завершить отчет по проекту
     ```
   - Если графическая система недоступна, напоминание записывается в файл `~/reminders.log`:
     ```
     [2024-12-25 15:00] Завершить отчет по проекту
     ```

4. **Просмотр запланированных задач:**  
   Пользователь может ввести команду:
   ```bash
   atq
   ```
   Это покажет список всех запланированных задач с их номерами.

5. **Удаление задачи (по желанию):**  
   Если пользователь хочет удалить задачу, он может использовать:
   ```bash
   atrm <номер задачи>
   ```

---

### Советы по выполнению

- Перед использованием команды `at` убедитесь, что служба `atd` запущена:
  ```bash
  sudo systemctl start atd
  ```

- Для проверки, работает ли команда `notify-send`, выполните:
  ```bash
  notify-send "Тест уведомления"
  ```

- Если вы работаете на сервере без графической оболочки, уведомления через `notify-send` не сработают. Используйте запись в лог-файл.

---

### Пример работы скрипта:

Запуск:
```bash
./reminder.sh
```

Пример взаимодействия:
```
Введите текст напоминания:
Сдать отчет до конца дня

Введите время напоминания (например, 'now + 30 minutes' или 'tomorrow at 9am'):
now + 2 hours

Напоминание успешно запланировано!
```

Через 2 часа на экране появляется уведомление:  
> Сдать отчет до конца дня  

Если графическая система недоступна, напоминание записывается в файл `~/reminders.log`.

---

### Как успешно сдать работу?

1. Напишите и протестируйте скрипт.
2. В отчете опишите:
   - Логику работы скрипта;
   - Скриншоты выполнения;
   - Лог выполнения напоминаний.
3. Подготовьте файл `.md`, оформленный в соответствии с заданием.

---

### Полезные источники:

1. [Документация по `at`](https://linux.die.net/man/1/at)
2. [Основы Shell-скриптов](https://www.opennet.ru/docs/RUS/bash_scripting_guide/)
3. [Как использовать команду at ](https://blog.sedicomm.com/2017/11/21/kak-ispolzovat-komandu-at-dlya-planirovaniya-zadachi-v-linux/)
4. [Универсальный источник](https://www.google.com/)