use Tk;
use Tk::Text;
use Tk::Dialog;

# Create a main window
my $root = MainWindow->new;
$root->title("ASCII to Ternary Converter with Caesar Cipher");

# Create input and output text areas
my $input_textarea = $root->Text(
    -height => 10,
    -width  => 50
)->pack();

my $output_textarea = $root->Text(
    -height => 10,
    -width  => 50
)->pack();

# Create Encode and Decode buttons
my $encode_button = $root->Button(
    -text    => "Encode",
    -command => \&encode_text
)->pack();

my $decode_button = $root->Button(
    -text    => "Decode",
    -command => \&decode_text
)->pack();

# Create labels
my $input_label = $root->Label(-text => "Input Text:")->pack();
my $output_label = $root->Label(-text => "Output Text:")->pack();

MainLoop;

sub ascii_to_ternary {
    my ($text) = @_;
    eval {
        my $ternary_text = '';
        for my $char (split //, $text) {
            my $ternary_char = sprintf("%03o", ord($char));  # Convert ASCII to ternary
            $ternary_text .= $ternary_char;
        }
        return $ternary_text;
    } or do {
        show_error_popup("Encoding Error", $@);
    };
}

sub ternary_to_ascii {
    my ($ternary_text) = @_;
    eval {
        my $ascii_text = '';
        for (my $i = 0; $i < length($ternary_text); $i += 3) {
            my $ternary_char = substr($ternary_text, $i, 3);
            my $ascii_char = chr(oct("0" . $ternary_char));  # Convert ternary to ASCII
            $ascii_text .= $ascii_char;
        }
        return $ascii_text;
    } or do {
        show_error_popup("Decoding Error", $@);
    };
}

sub caesar_cipher {
    my ($text, $shift) = @_;
    eval {
        my $result = '';
        for my $char (split //, $text) {
            if ($char =~ /[A-Za-z]/) {
                my $shift_amount = $shift % 26;  # Ensure shift is within 26 characters
                if ($char =~ /[a-z]/) {
                    my $ord_a = ord('a');
                    my $shifted_char = chr((ord($char) - $ord_a + $shift_amount) % 26 + $ord_a);
                    $result .= $shifted_char;
                } else {
                    my $ord_A = ord('A');
                    my $shifted_char = chr((ord($char) - $ord_A + $shift_amount) % 26 + $ord_A);
                    $result .= $shifted_char;
                }
            } else {
                $result .= $char;
            }
        }
        return $result;
    } or do {
        show_error_popup("Caesar Cipher Error", $@);
    };
}

sub show_error_popup {
    my ($title, $message) = @_;
    my $dialog = $root->Dialog(
        -title          => $title,
        -text           => $message,
        -buttons        => ['OK'],
        -default_button => 'OK'
    );
    $dialog->Show();
}

sub encode_text {
    my $input_text = $input_textarea->get('1.0', 'end-1c');
    eval {
        my $caesar_shift = 1;  # You can adjust the Caesar Cipher shift amount (-1, 0, +1)
        my $caesar_encoded = caesar_cipher($input_text, $caesar_shift);
        my $reversed_text = reverse($caesar_encoded);  # Reverse the Caesar-encoded text
        my $ternary_text = ascii_to_ternary($reversed_text);
        $output_textarea->delete('1.0', 'end');
        $output_textarea->insert('1.0', $ternary_text);
    } or do {
        show_error_popup("Encoding Error", $@);
    };
}

sub decode_text {
    my $input_text = $input_textarea->get('1.0', 'end-1c');
    eval {
        my $reversed_text = ternary_to_ascii($input_text);
        my $caesar_shift = -1;  # You need to use the same shift as used in encoding (-1, 0, +1)
        my $caesar_decoded = caesar_cipher(reverse($reversed_text), $caesar_shift);  # Reverse and decode
        $output_textarea->delete('1.0', 'end');
        $output_textarea->insert('1.0', $caesar_decoded);
    } or do {
        show_error_popup("Decoding Error", $@);
    };
}
