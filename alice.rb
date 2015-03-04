require 'sdl'

SDL.init(SDL::INIT_VIDEO)
screen = SDL::Screen.open(640, 480, 16, SDL::SWSURFACE)
SDL::WM::set_caption('RCPU', 'RCPU')

BLACK = screen.format.map_rgb(0, 0, 0)
WHITE = screen.format.map_rgb(255, 255, 255)

FONTS = {
  '0' => [0b1111, 0b1001, 0b1001, 0b1001, 0b1111],
  '1' => [0b0010, 0b0110, 0b0010, 0b0010, 0b0111],
  '2' => [0b1111, 0b0001, 0b1111, 0b1000, 0b1111],
  '3' => [0b1111, 0b0001, 0b1111, 0b0001, 0b1111],
  '4' => [0b1001, 0b1001, 0b1111, 0b0001, 0b0001],
  '5' => [0b1111, 0b1000, 0b1111, 0b0001, 0b1111],
  '6' => [0b1111, 0b1000, 0b1111, 0b1001, 0b1111],
  '7' => [0b1111, 0b0001, 0b0010, 0b0100, 0b0100],
  '8' => [0b1111, 0b1001, 0b1111, 0b1001, 0b1111],
  '9' => [0b1111, 0b1001, 0b1111, 0b0001, 0b1111],
  'A' => [0b1111, 0b1001, 0b1111, 0b1001, 0b1001],
  'B' => [0b1110, 0b1001, 0b1110, 0b1001, 0b1110],
  'C' => [0b0111, 0b1000, 0b1000, 0b1000, 0b0111],
  'D' => [0b1110, 0b1001, 0b1001, 0b1001, 0b1110],
  'E' => [0b1111, 0b1000, 0b1111, 0b1000, 0b1111],
  'F' => [0b1111, 0b1000, 0b1111, 0b1000, 0b1000],
  'G' => [0b0111, 0b1000, 0b1011, 0b1001, 0b0111],
  'H' => [0b1001, 0b1001, 0b1111, 0b1001, 0b1001],
  'I' => [0b1111, 0b0010, 0b0010, 0b0010, 0b1111],
  'J' => [0b0111, 0b0001, 0b0001, 0b0001, 0b0110],
  'K' => [0b1001, 0b1010, 0b1100, 0b1010, 0b1001],
  'L' => [0b1000, 0b1000, 0b1000, 0b1000, 0b1111],
  'M' => [0b1011, 0b1111, 0b1101, 0b1001, 0b1001],
  'N' => [0b1001, 0b1101, 0b1011, 0b1001, 0b1001],
  'O' => [0b0110, 0b1001, 0b1001, 0b1001, 0b0110],
  'P' => [0b1110, 0b1001, 0b1110, 0b1000, 0b1000],
  'Q' => [0b0110, 0b1001, 0b1001, 0b1011, 0b0111],
  'R' => [0b1110, 0b1001, 0b1110, 0b1010, 0b1001],
  'S' => [0b0111, 0b1000, 0b0110, 0b0001, 0b1110],
  'T' => [0b1111, 0b0100, 0b0100, 0b0100, 0b0100],
  'U' => [0b1001, 0b1001, 0b1001, 0b1001, 0b0110],
  'V' => [0b1001, 0b1001, 0b1010, 0b1010, 0b0100],
  'W' => [0b1001, 0b1001, 0b1011, 0b1111, 0b1010],
  'X' => [0b1001, 0b1001, 0b0110, 0b1001, 0b1001],
  'Y' => [0b1001, 0b0101, 0b0010, 0b0010, 0b0010],
  'Z' => [0b1111, 0b0010, 0b0100, 0b1000, 0b1111],
  '.' => [0b0000, 0b0000, 0b0000, 0b0000, 0b0100],
  ',' => [0b0000, 0b0000, 0b0000, 0b0010, 0b0100],
  ' ' => [0b0000, 0b0000, 0b0000, 0b0000, 0b0000],
  '!' => [0b0100, 0b0100, 0b0100, 0b0000, 0b0100],
  '?' => [0b0110, 0b1001, 0b0010, 0b0000, 0b0010],
  ':' => [0b0000, 0b0100, 0b0000, 0b0100, 0b0000],
  '“' => [0b0101, 0b1010, 0b1010, 0b0000, 0b0000],
  '”' => [0b0101, 0b0101, 0b1010, 0b0000, 0b0000],
  '(' => [0b0010, 0b0100, 0b0100, 0b0100, 0b0010],
  ')' => [0b0100, 0b0010, 0b0010, 0b0010, 0b0100],
}

SIZE_X = 4
SIZE_Y = 4

SPRITE_WIDTH = 4
SPRITE_HEIGHT = 5

OFFSET_X = 1
OFFSET_Y = 1

def draw_char(s, dx, dy, screen)
  char = FONTS[s]
  return if char.nil?
  char.each_with_index do |byte, y|
    format('%08b', byte).bytes.last(4).map { |i| i == 49 }.each_with_index do |bit, x|
      if bit
        screen.fill_rect(
          dx * SPRITE_WIDTH*SIZE_X  + x * SIZE_X + dx * OFFSET_X * SIZE_X,
          dy * SPRITE_HEIGHT*SIZE_Y + y * SIZE_Y + dy * OFFSET_Y * SIZE_Y,
          SIZE_X,
          SIZE_Y,
          WHITE
        )
      end
    end
  end
end

def draw_string(s, dx, dy, screen)
  s.chars.each_with_index do |char, index|
    draw_char(char.upcase, dx + index, dy, screen)
  end
end

paragraphs = [
  'Alice was beginning to get very',
  'tired of sitting by her sister',
  'on the bank, and of having',
  'nothing to do: once or twice she',
  'had peeped into the book her',
  'sister was reading, but it had',
  'no pictures or conversations in',
  'it, “and what is the use of a',
  'book,” thought Alice “without',
  'pictures or conversations?”',
  '',
  'So she was considering in her',
  'own mind (as well as she could,',
  'for the hot day made her feel',
  'very sleepy and stupid), whether',
  'the pleasure of making a daisy-',
  'chain would be worth the trouble',
  'of getting up and picking the',
  'daisies, when suddenly a White',
  'Rabbit with pink eyes ran close',
  'by her.',
]

MAX_WIDTH = 32

paragraphs.each_with_index do |paragraph, paragraph_index|
  paragraph.scan(/.{1,32}/).each_with_index do |string, line_index|
    draw_string(string, 0, paragraph_index + line_index, screen)
  end
end

screen.flip

loop { sleep 1 }
