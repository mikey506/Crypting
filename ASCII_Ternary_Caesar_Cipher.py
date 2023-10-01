import tkinter as tk
from tkinter import messagebox

def ascii_to_ternary(text):
    try:
        ternary_text = ''
        for char in text:
            ternary_char = format(ord(char), '03o')  # Convert ASCII to ternary
            ternary_text += ternary_char
        return ternary_text
    except Exception as e:
        show_error_popup("Encoding Error", str(e))

def ternary_to_ascii(ternary_text):
    try:
        ascii_text = ''
        for i in range(0, len(ternary_text), 3):
            ternary_char = ternary_text[i:i+3]
            ascii_char = chr(int(ternary_char, 8))  # Convert ternary to ASCII
            ascii_text += ascii_char
        return ascii_text
    except Exception as e:
        show_error_popup("Decoding Error", str(e))

def caesar_cipher(text, shift):
    try:
        result = ''
        for char in text:
            if char.isalpha():
                if char.islower():
                    shifted_char = chr(((ord(char) - ord('a') + shift) % 26) + ord('a'))
                else:
                    shifted_char = chr(((ord(char) - ord('A') + shift) % 26) + ord('A'))
                result += shifted_char
            else:
                result += char
        return result
    except Exception as e:
        show_error_popup("Caesar Cipher Error", str(e))

def show_error_popup(title, message):
    messagebox.showerror(title, message)

def encode_text():
    input_text = input_textarea.get("1.0", "end-1c")
    try:
        caesar_shift = 1  # You can adjust the Caesar Cipher shift amount (-1, 0, +1)
        caesar_encoded = caesar_cipher(input_text, caesar_shift)
        reversed_text = caesar_encoded[::-1]  # Reverse the Caesar-encoded text
        ternary_text = ascii_to_ternary(reversed_text)
        output_textarea.delete("1.0", "end")
        output_textarea.insert("1.0", ternary_text)
    except Exception as e:
        show_error_popup("Encoding Error", str(e))

def decode_text():
    input_text = input_textarea.get("1.0", "end-1c")
    try:
        reversed_text = ternary_to_ascii(input_text)
        caesar_shift = -1  # You need to use the same shift as used in encoding (-1, 0, +1)
        caesar_decoded = caesar_cipher(reversed_text[::-1], caesar_shift)  # Reverse and decode
        output_textarea.delete("1.0", "end")
        output_textarea.insert("1.0", caesar_decoded)
    except Exception as e:
        show_error_popup("Decoding Error", str(e))

# Create the main window
root = tk.Tk()
root.title("ASCII to Ternary Converter with Caesar Cipher")

# Create input and output text areas
input_textarea = tk.Text(root, height=10, width=50)
output_textarea = tk.Text(root, height=10, width=50)

# Create Encode and Decode buttons
encode_button = tk.Button(root, text="Encode", command=encode_text)
decode_button = tk.Button(root, text="Decode", command=decode_text)

# Create labels
input_label = tk.Label(root, text="Input Text:")
output_label = tk.Label(root, text="Output Text:")

# Place widgets in the window
input_label.pack()
input_textarea.pack()
encode_button.pack()
decode_button.pack()
output_label.pack()
output_textarea.pack()

# Run the GUI application
root.mainloop()
