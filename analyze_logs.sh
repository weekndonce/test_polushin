#!/bin/bash

LOG_FILE="access.log"
REPORT_FILE="report.txt"

if [ ! -f "$LOG_FILE" ]; then
    echo "Ошибка: Файл $LOG_FILE не найден!"
    exit 1
fi

echo "Анализ логов: $LOG_FILE" > $REPORT_FILE
echo "=================================" >> $REPORT_FILE

TOTAL_REQUESTS=$(wc -l < $LOG_FILE)
echo "1. Общее количество запросов: $TOTAL_REQUESTS" >> $REPORT_FILE

UNIQUE_IPS=$(awk '{print $1}' $LOG_FILE | sort | uniq | wc -l)
echo "2. Количество уникальных IP-адресов: $UNIQUE_IPS" >> $REPORT_FILE

echo "3. Количество запросов по методам:" >> $REPORT_FILE
awk '{ 
    method = substr($6, 2) 
    count[method]++ 
} 
END { 
    for (m in count) print "   " m ": " count[m] 
}' $LOG_FILE >> $REPORT_FILE

echo "4. Самый популярный URL:" >> $REPORT_FILE
POPULAR_URL=$(awk '{print $7}' $LOG_FILE | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
POPULAR_COUNT=$(awk '{print $7}' $LOG_FILE | sort | uniq -c | sort -nr | head -n 1 | awk '{print $1}')
echo "   $POPULAR_URL (количество запросов: $POPULAR_COUNT)" >> $REPORT_FILE

echo "=================================" >> $REPORT_FILE
echo "Отчет сохранен в файл: $REPORT_FILE"
cat $REPORT_FILE

