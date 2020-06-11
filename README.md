# Distributed_Systems
Реалізовано сервер який проводить сортування чисел алгоритмом прямим включенням.
Числа задаються клієнтом які мають бути сформовані у файлі.
Запуск сервера:
     cd("c://ерланг5").
     sequential_server:start_seq_server().
Запуск клієнта:
     {ok, File} = file:read_file("C://ерланг5/list_of_numbers.txt"). – проводимо зчитування нашого файлу з числами.
     Content = unicode:characters_to_list(File). – формуємо лист з даних які є у цьому файлі.
     L = [begin {Int,_}=string:to_integer(Token), Int end|| Token<-string:tokens(Content," ")]. – перетворюємо попередній лист даних у список і присвоюємо цей список змінній  L.
     sequential_server:nano_client_eval(L). – відправляємо сформований список на сервер для сортування даних.
Далі можна відкрити у поточній аудиторії файл з результатом і побачити список чисел які є посортованими.
