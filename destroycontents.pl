#!/usr/bin/perl
use strict;
use warnings;
use SVN::Dump;

my $file = shift;
my $dump = SVN::Dump->new( { file => $file } );

while ( my $record = $dump->next_record() ) {
	process_record($record);
	
	my $included = $record->get_included_record();
	if (defined $included) {
		process_record($included);
	}
	
	print $record->as_string();
}

sub process_record {
	my ($record) = @_;
	
	if ($record->has_text()) {
		my $text_block = $record->get_text_block();
		my $text = $text_block->get();
		my $length = length $text;
		my $new_text = generate_random_text($text, $length);
		$text_block->set($new_text);
	}
	
	my $headers_block = $record->get_headers_block();
	delete $headers_block->{'Text-copy-source-md5'};
	delete $headers_block->{'Text-content-md5'};
}

sub generate_random_text {
	my ($text, $length) = @_;
	
	if (($length > 5) && ($length < 1000) && ($text =~ m/^link\ /)) {
		return $text;
	}
	
	my $new_text = "";
	for (my $i = 0; $i < $length; $i++) {
		$new_text .= ".";
	}
	
	return $new_text;
}
