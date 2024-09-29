#include "MessageHistory.h"
#include <QTime>
// Конструктор
MessageHistory::MessageHistory(QObject *parent) : QObject(parent) {}

// Метод для добавления сообщения в историю
void MessageHistory::addMessage(const QString &message) {

    QTime currentTime = QTime::currentTime();

    // Преобразуем время в строку
    QString timeString = currentTime.toString("hh:mm:ss");

    m_messages.append(timeString + " : /n");
    m_messages.append(message);
    emit messagesUpdated();  // Уведомляем об изменении
}

// Метод для получения всех сообщений как одной строки
QString MessageHistory::allMessages() const {
    return m_messages.join("\n");  // Возвращаем сообщения через перенос строки
}
