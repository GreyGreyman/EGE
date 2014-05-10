# Copyright © 2010 Alexander S. Klenin
# Licensed under GPL version 2 or later.
# http://github.com/klenin/EGE

package EGE::Gen::A14;
use base 'EGE::GenBase::SingleChoice';

use strict;
use warnings;
use utf8;

use EGE::Random;
use EGE::Prog;
use EGE::Prog::Lang;
use EGE::Html;
use EGE::Russian::FamilyNames;
use EGE::Russian::Subjects;
use EGE::SQL::Table;

sub database {
    my ($self) = @_;
    my @families = rnd->pick_n_sorted(6, @EGE::Russian::FamilyNames::list);
    my @subjects = rnd->pick_n(5, grep !/\s/, @EGE::Russian::Subjects::list);
    my $table = EGE::SQL::Table->new([ qw(Фамилия Пол), @subjects ]);
    for (@families) {
        my $sex = rnd->coin;
        my $name = $_.($sex ? '' : 'а');
        $table->insert_row(
            $name,
            $sex,
            map rnd->in_range(50, 90), @subjects
        );
    }; 
    
    my $cond = '';
    my $count = 0;
    my $tab;
    while (1) {
        my ($s1, $s2) = rnd->pick_n(2, 0 .. @subjects - 1);
        my $sex = rnd->coin ? 1 : 0;
        my $e = EGE::Prog::make_expr([
            rnd->pick('&&', '||'),
            [ '==', 'Пол', \$sex ],
            [ rnd->pick(ops::comp), @subjects[$s1, $s2] ],
        ]);
        $tab = $table->select([], $e);
        $count = $tab->count();
        if ($count) {
            $sex = $sex ? q~'м'~ : q~'ж'~;
            $cond = html->cdata($e->to_lang_named('Alg'));
            last;
        }
    }
    $table->update (["Пол"], sub {$_[0] ?'м':'ж';});
    my $table_text = html->row_n('th', @{$table->{fields}});
    $table_text .= html->row_n('td', @$_) for @{$table->{data}};
    $table_text = html->table($table_text, { border => 1 });
    $self->{text} =
        "Результаты тестирования представлены в таблице\n$table_text\n" .
        "Сколько записей в ней удовлетворяют условию «$cond»?",
    $self->variants($count, rnd->pick_n(3, grep $_ != $count, 1 .. $table->count));
}

1;