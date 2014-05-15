# Copyright © 2014 Darya D. Gornak 
# Licensed under GPL version 2 or later.
# http://github.com/dahin/EGE

package EGE::SQL::Select;

use strict;
use warnings;
use EGE::Html;
use EGE::Random;
use EGE::Prog;
use EGE::Prog::Lang;

sub new { 
    my ($class, $table, $name, $fields, $where) = @_;
    $fields or die;
    my $self = {
        table => $table,
        fields => $fields,
        where => $where,
        table_name => $name,
    };
    bless $self, $class;
    $self;
}

sub run {
    my ($self) = @_;
    my $ans = $self->{table}->select($self->{fields}, $self->{where});
    $ans;
}

sub text {
    my ($self) = @_;
    my $ans = "<tt>SELECT ";
    for (@{$self->{fields}}) {
        if (!ref ($_)) {
            $ans .= "$_, ";
        } else {
            $ans .= html->cdata($_->to_lang_named('SQL')). ", ";
        }    
    }
    $ans = substr($ans, 0, -2) if (${$self->{fields}}[0]);
    $ans .= "*" if (!${$self->{fields}}[0]);
    $ans .= " FROM ".$self->{table_name};
    $ans .= " WHERE ". html->cdata($self->{where}->to_lang_named('SQL')) if $self->{where};
    $ans .="</tt>";
}

package EGE::SQL::Update;

use strict;
use warnings;
use EGE::Html;

sub new { 
    my ($class, $table, $name, $fields, $exp, $where, $text_func) = @_;
    $fields or die;
    my $self = {
        table => $table,
        fields => $fields,
        exp => $exp,
        where => $where,
        table_name => $name,
        text_func => $text_func,
    };
    bless $self, $class;
    $self;
}

sub run {
    my ($self) = @_;
    $self->{table}->update($self->{fields}, $self->{exp}, $self->{where});
}

sub text {
    my ($self) = @_;
    my $ans = "<tt>UPDATE ".$self->{table_name}." SET ";
    my $i = 0;
    for (@{$self->{fields}}) {
        $ans .= "$_ = ";
        my $j = ${$self->{exp}}[$i];
        if (!ref($j)) {
            $ans .= "$j, ";
        } else {
            if (ref($j) eq "CODE"){
                $ans .= ${$self->{text_func}}[$i]. ", ";
            } else {
                $ans .= html->cdata($j->to_lang_named('SQL')). ", ";
            }
        }    
        $i++;
    }
    $ans = substr($ans, 0, -2);
    $ans .= " WHERE ".html->cdata($self->{where}->to_lang_named('SQL')) if $self->{where};
    $ans .="</tt>";
}

package EGE::SQL::Delete;

use strict;
use warnings;
use EGE::Html;

sub new { 
    my ($class, $table, $name, $where) = @_;
    my $self = {
        table => $table,
        where => $where,
        table_name => $name,
    };
    bless $self, $class;
    $self;
}

sub run {
    my ($self) = @_;
    $self->{table}->delete($self->{where});
}

sub text {
    my ($self) = @_;
    my $ans = "<tt>DELETE FROM ".$self->{table_name}." WHERE ";
    $ans .=  html->cdata($self->{where}->to_lang_named('SQL'));
    $ans .="</tt>";
}

1