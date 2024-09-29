#ifndef MESSAGEHISTORY_H
#define MESSAGEHISTORY_H

#include <QObject>
#include <QStringList>

class MessageHistory : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString allMessages READ allMessages NOTIFY messagesUpdated)

public:
    explicit MessageHistory(QObject *parent = nullptr);

    // Метод для добавления сообщения в историю
     void addMessage(const QString &message);

    // Метод для получения всех сообщений как одной строки
    Q_INVOKABLE QString allMessages() const;


signals:
    // Сигнал для уведомления об обновлении списка сообщений
    void messagesUpdated();

private:
    QStringList m_messages;  // Хранит историю сообщений
};

#endif // MESSAGEHISTORY_H
