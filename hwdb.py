import psycopg2
from pprint import pprint


def create_db(cur):
    cur.execute("""
        CREATE TABLE IF NOT EXISTS clients(
            id SERIAL PRIMARY KEY,
            name VARCHAR(30),
            lastname VARCHAR(30),
            email VARCHAR(100)
            );
        """)
    cur.execute("""
    CREATE TABLE IF NOT EXISTS numbers(
        number VARCHAR(11),
        client_id INTEGER REFERENCES clients(id)
        );
    """)
    return


def add_phones(cur, client_id, number):
    cur.execute("""
        INSERT INTO numbers(number, client_id)
        VALUES(%s, %s);
    """, (number, client_id))
    return client_id


def delete_db(cur):
    cur.execute("""
        DROP TABLE clients, numbers;
        """)

        
def add_clients(cur, name, lastname, email, number=None):
    cur.execute("""
        INSERT INTO clients(name, lastname, email)
        VALUES(%s, %s, %s);
    """, (name, lastname, email))
    cur.execute("""
        SELECT id from clients
        ORDER BY id DESC
        LIMIT 1
    """)
    id = cur.fetchone()[0]
    if number is None:
        return id
    else:
        add_phones(cur, id, number)
        return id
        

def change_client(cur, id, name=None, lastname=None, email=None):
    cur.execute("""
        SELECT * FROM clients
        WHERE id = %s;
    """, (id, ))
    cur.execute("""
        UPDATE clients SET name=%s, lastname=%s, email=%s 
        WHERE id=%s;
    """, (name, lastname, email, id))
    return id


def delete_phone(cur, phonenumber):
    cur.execute("""
        DELETE FROM numbers 
        WHERE number=%s;
    """, (phonenumber,))
    return phonenumber


def delete_client(cur, id):
    cur.execute("""
        DELETE FROM numbers 
        WHERE client_id=%s;
    """, (id,))
    cur.execute("""
        DELETE FROM clients 
        WHERE id=%s;
    """, (id,))
    return id
        

def find_client(cur, name=None, last_name=None, email=None, phone=None):
    if name is None:
        name = '%'
    else:
        name = '%' + name + '%'
    if last_name is None:
        last_name = '%'
    else:
        last_name = '%' + last_name + '%'
    if email is None:
        email = '%'
    else:
        email = '%' + email + '%'
    if phone is None:
        cur.execute("""
            SELECT c.id, c.name, c.lastname, c.email, n.number FROM clients c
            JOIN numbers n ON c.id = n.client_id
            WHERE c.name LIKE %s and c.lastname LIKE %s AND c.email LIKE %s;
            """, (name, last_name, email))
    else:
        cur.execute("""
            SELECT c.id, c.name, c.lastname, c.email, n.number FROM clients c
            JOIN numbers n ON c.id = n.client_id
            WHERE c.name LIKE %s and c.lastname LIKE %s AND c.email LIKE %s AND n.phone LIKE %s;
            """, (name, last_name, email, phone))
    return cur.fetchall()
        

if __name__ == '__main__':
    with psycopg2.connect(database="netology_db", user="postgres", password="Kirushka1488") as conn:
        with conn.cursor() as cur:
            create_db(cur)
            print("БД создана")
            add_clients(cur, "Иван", "Иванов", "ivan@mail.ru")
            print("Добавлен клиент id: ")
            add_clients(cur, "Константин", "Константинов", "konstantin@mail.ru", 79993318644)
            print("Добавлен клиент id: ")
            add_clients(cur, "Петр", "Петров", "petr@mail.ru", 79933314644)
            print("Добавлен клиент id: ")
            add_clients(cur, "Владимир", "Владимиров", "k8sjebg1y@mail.ru", 79913312643)
            print("Добавлен клиент id: ")
            add_clients(cur, "Сидр", "Пивов", "sidrpidr@mail.ru")
            print("Добавлен клиент id: ")
            print("Все клиенты успешно добавлены")
            cur.execute("""
                SELECT c.id, c.name, c.lastname, c.email, n.number FROM clients c
                LEFT JOIN numbers n ON c.id = n.client_id
                ORDER by c.id
                """)
            pprint(cur.fetchall())
            add_phones(cur, 5, 79877876543)
            print("Телефон добавлен клиенту id: ")
            add_phones(cur, 1, 79621994802)
            print("Телефон добавлен клиенту id: ")
            print("Номера телефонов успешно добавлены")
            cur.execute("""
                SELECT c.id, c.name, c.lastname, c.email, n.number FROM clients c
                LEFT JOIN numbers n ON c.id = n.client_id
                ORDER by c.id
                """)
            pprint(cur.fetchall())
            change_client(cur, 4, "Савелий", "Пуговкин", "123@mail.ru")
            print("Изменены данные клиента id: ")
            cur.execute("""
                SELECT c.id, c.name, c.lastname, c.email, n.number FROM clients c
                LEFT JOIN numbers n ON c.id = n.client_id
                ORDER by c.id
                """)
            pprint(cur.fetchall())
            delete_phone(cur, '79621994802')
            print("Удален телефон клиента id: ")
            cur.execute("""
                SELECT c.id, c.name, c.lastname, c.email, n.number FROM clients c
                LEFT JOIN numbers n ON c.id = n.client_id
                ORDER by c.id
                """)
            pprint(cur.fetchall())
            delete_client(cur, 2)
            print("Удален клиент id: ")
            cur.execute("""
                SELECT c.id, c.name, c.lastname, c.email, n.number FROM clients c
                LEFT JOIN numbers n ON c.id = n.client_id
                ORDER by c.id
                """)
            pprint(cur.fetchall())
            print('Найден клиент по имени:')
            pprint(find_client(cur, 'Константин', None, None))
