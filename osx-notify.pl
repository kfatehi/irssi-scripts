##
## Put me in ~/.irssi/scripts, and then execute the following in irssi:
##
##       /script load osx-notify
##

use strict;
use Irssi;
use vars qw($VERSION %IRSSI);
use HTML::Entities;


$VERSION = "0.0.1";
%IRSSI = (
    authors     => 'Keyvan Fatehi',
    contact     => 'keyvanfatehi@gmail.com',
    name        => 'osx-notify.pl',
    description => 'Use Terminal-Notifier to alert user to hilighted messages',
    license     => 'ISC',
    url         => 'https://github.com/keyvanfatehi/irssi-scripts/osx-notify',
);

# FIXME take out that version number!
my $tn = "/usr/local/Cellar/terminal-notifier/1.6.0/terminal-notifier.app/Contents/MacOS/terminal-notifier";

sub notify {
    my ($server, $summary, $message) = @_;

    # Make the message entity-safe.
    encode_entities($message);

    system($tn . " -title irssi" .
      " -subtitle \"" . $summary ."\"" .
      " -message \"" . $message . "\"");
}
 
sub print_text_notify {
    my ($dest, $text, $stripped) = @_;
    my $server = $dest->{server};

    return if (!$server || !($dest->{level} & MSGLEVEL_HILIGHT));
    notify($server, $dest->{target}, $stripped);
}

sub message_private_notify {
    my ($server, $msg, $nick, $address) = @_;

    return if (!$server);
    notify($server, "Private message from ".$nick, $msg);
}

sub dcc_request_notify {
    my ($dcc, $sendaddr) = @_;
    my $server = $dcc->{server};

    return if (!$server || !$dcc);
    notify($server, "DCC ".$dcc->{type}." request", $dcc->{nick});
}

if (-e $tn) {
  Irssi::signal_add('print text', 'print_text_notify');
  Irssi::signal_add('message private', 'message_private_notify');
  Irssi::signal_add('dcc request', 'dcc_request_notify');
  print "osx-notify plugin loaded.";
} else {
  print "To use osx-notify you must brew install terminal-notifier and reload the script";
  print "Is it already installed? See FIXME notice in the script";
}
