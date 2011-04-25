package EGE::Russian::Names;

use strict;
use warnings;
use utf8;

use EGE::Random;

our @male = qw(
Августин
Авдей
Авраам
Агафон
Адам
Адриан
Аким
Алан
Александр
Алексей
Альберт
Альфред
Амвросий
Ананий
Анастасий
Анатолий
Андрей
Антон
Аристарх
Аркадий
Арнольд
Арсений
Артем
Артемий
Артур
Архип
Афанасий
Богдан
Борис
Булат
Вадим
Валентин
Валерий
Василий
Вениамин
Виктор
Виссарион
Виталий
Владимир
Владислав
Всеволод
Вячеслав
Геннадий
Георгий
Герман
Глеб
Григорий
Даниил
Дементий
Демьян
Денис
Дмитрий
Евгений
Егор
Ефим
Захар
Зиновий
Иван
Игнатий
Игорь
Иннокентий
Кирилл
Клим
Константин
Кузьма
Лавр
Лаврентий
Лев
Леонид
Леонтий
Лука
Лукьян
Макарий
Максимилиан
Марат
Матвей
Митрофан
Михаил
Михей
Наум
Нестор
Никита
Николай
Олег
Олесь
Осип
Оскар
Павел
Петр
Платон
Родион
Роман
Ростислав
Савва
Самсон
Семён
Серафим
Сергей
Степан
Тимофей
Тимур
Тихон
Устин
Федор
Федот
Филимон
Флор
Фома
Харитон
Христиан
Эдгар
Эдуард
Эльдар
Эмиль
Эммануил
Эрик
Юлиан
Юлий
Юрий
Яков
Ян
Яромир
Ярослав
);

our @female = qw(
Аврора
Агата
Агнесса
Агния
Ада
Аза
Алевтина
Александра
Алина
Алиса
Алла
Альбина
Альфреа
Анастасия
Ангелина
Анжелика
Анита
Анна
Антонина
Анфиса
Арина
Астра
Беата
Белла
Берта
Богдана
Борислава
Бронислава
Валентина
Валерия
Ванда
Варвара
Василиса
Венера
Вера
Вероника
Веста
Виктория
Виолетта
Галина
Гелена
Гелла
Генриетта
Гертруда
Глафира
Глория
Дарья
Джульета
Диана
Дина
Доминика
Ева
Евгения
Евдокия
Екатерина
Елена
Елизавета
Жанна
Зинаида
Зоя
Иветта
Изабелла
Изольда
Илья
Инара
Инга
Инесса
Инна
Ирина
Ирма
Камилла
Капитолина
Карина
Каролина
Катарина
Кира
Клавдия
Клара
Кристина
Ксения
Кузьма
Лада
Лайма
Лариса
Леся
Лиана
Лидия
Лилия
Лиана
Людмила
Майя
Маргарита
Марианна
Марина
Мария
Марта
Марфа
Милена
Мирра
Надежда
Наталия
Никита
Нина
Нонна
Нора
Оксана
Олеся
Ольга
Полина
Прасковья
Раиса
Регина
Рената
Римма
Роза
Роксана
Руслана
Руфина
Савва
Сара
Светлана
Серафима
София
Станислава
Стелла
Стефания
Сюзанна
Таира
Таисия
Тамара
Татьяна
Ульяна
Фаина
Фекла
Флора
Фома
Франсуаза
Фрида
Христина
Эдита
Элеонора
Эвелина
Эльвира
Эльза
Эмилия
Эрика
Юлия
Юнона
Ядвига
Яна
Ярослава
);

our @list = (@male, @female);

my $h;

sub different_names {
    my ($count) = @_;
    $h ||= { map { $_, [] } 'А' .. 'Я' };
    for (@EGE::Russian::Names::male) {
        push @{$h->{substr($_, 0, 1)}}, { name => $_, gender => 0 };
    }
    for (@EGE::Russian::Names::female) {
        push @{$h->{substr($_, 0, 1)}}, { name => $_, gender => 1 }
    }
    map { rnd->pick(@{$h->{$_}}) } rnd->pick_n($count, keys %{$h});
}

1;
