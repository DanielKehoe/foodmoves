#  # Automatically generate a phonemic password
#  password = PhonemicPassword.generate(12)
 
class PhonemicPassword
  
  VERSION = '0.2'

  # :stopdoc:

  # phoneme flags
  #
  CONSONANT = 1
  VOWEL	    = 1 << 1
  DIPHTHONG = 1 << 2
  NOT_FIRST = 1 << 3
  NOT_LAST  = 1 << 4
  RARE      = 1 << 5

  PHONEMES = {
    :a	=> VOWEL,
    :ae	=> VOWEL      | DIPHTHONG | NOT_FIRST | NOT_LAST | RARE,
    :ah => VOWEL      | DIPHTHONG,
    :ai => VOWEL      | DIPHTHONG,
    :ao => VOWEL      | DIPHTHONG,
    :au => VOWEL      | DIPHTHONG,
    :aw => VOWEL      | DIPHTHONG,
    :ay => VOWEL      | DIPHTHONG | NOT_FIRST,
    :b	=> CONSONANT,
    :bl	=> CONSONANT  | DIPHTHONG | NOT_LAST,
    :br	=> CONSONANT  | DIPHTHONG | NOT_LAST,
    :c	=> CONSONANT  | NOT_LAST,
    :ch	=> CONSONANT  | DIPHTHONG,
    :cl	=> CONSONANT  | DIPHTHONG | NOT_LAST,
    :ck	=> CONSONANT  | DIPHTHONG | NOT_FIRST,
    :cr	=> CONSONANT  | DIPHTHONG | NOT_LAST,
    :d	=> CONSONANT,
    :dr	=> CONSONANT  | DIPHTHONG | NOT_LAST,
    :e	=> VOWEL,
    :ea	=> VOWEL      | DIPHTHONG,
    :ee	=> VOWEL      | DIPHTHONG | NOT_FIRST,
    :ei	=> VOWEL      | DIPHTHONG | NOT_FIRST | NOT_LAST,
    :eo	=> VOWEL      | DIPHTHONG | NOT_FIRST | NOT_LAST,
    :eu	=> VOWEL      | DIPHTHONG,
    :ew	=> VOWEL      | DIPHTHONG | NOT_FIRST,
    :f	=> CONSONANT | NOT_LAST,
    :ff	=> CONSONANT | NOT_FIRST,
    :fr	=> CONSONANT | NOT_LAST,
    :fl	=> CONSONANT | NOT_LAST,
    :g	=> CONSONANT,
    :gg	=> CONSONANT  | DIPHTHONG | NOT_FIRST | RARE,
    :gh	=> CONSONANT  | DIPHTHONG | NOT_FIRST,
    :gl	=> CONSONANT  | DIPHTHONG | NOT_LAST,
    :h	=> CONSONANT  | NOT_LAST,
    :i	=> VOWEL,
    :ia	=> VOWEL      | DIPHTHONG,
    :ie	=> VOWEL      | DIPHTHONG | NOT_FIRST | NOT_LAST,
    :j	=> CONSONANT  | NOT_LAST | RARE,
    :k	=> CONSONANT  | NOT_LAST | RARE,
    :kl	=> CONSONANT  | NOT_LAST | RARE,
    :kr	=> CONSONANT  | NOT_LAST | RARE,
    :l	=> CONSONANT,
    :ll	=> CONSONANT  | DIPHTHONG | NOT_FIRST | RARE,
    :ld	=> CONSONANT  | DIPHTHONG | NOT_FIRST,
    :lt	=> CONSONANT  | DIPHTHONG | NOT_FIRST,
    :ly	=> CONSONANT  | DIPHTHONG | NOT_FIRST,
    :m	=> CONSONANT,
    :mp	=> CONSONANT  | DIPHTHONG | NOT_FIRST,
    :n	=> CONSONANT,
    :ng	=> CONSONANT  | DIPHTHONG | NOT_FIRST,
    :nt	=> CONSONANT  | DIPHTHONG | NOT_FIRST,
    :o	=> VOWEL,
    :oh	=> VOWEL      | DIPHTHONG,
    :oo	=> VOWEL      | DIPHTHONG | RARE,
    :ough	=> VOWEL    | DIPHTHONG | NOT_FIRST | RARE,
    :ow	=> VOWEL      | DIPHTHONG,
    :p	=> CONSONANT,
    :ph	=> CONSONANT  | DIPHTHONG | NOT_LAST | RARE,
    :pl	=> CONSONANT  | DIPHTHONG | NOT_LAST | RARE,
    :pr	=> CONSONANT  | DIPHTHONG | NOT_LAST,
    :qu	=> CONSONANT  | DIPHTHONG | NOT_LAST | RARE,
    :r	=> CONSONANT,
    :rt	=> CONSONANT  | DIPHTHONG,
    :s	=> CONSONANT,
    :sh	=> CONSONANT  | DIPHTHONG,
    :sch	=> CONSONANT  | DIPHTHONG,
    :sk	=> CONSONANT  | DIPHTHONG,
    :st	=> CONSONANT  | DIPHTHONG,
    :t	=> CONSONANT,
    :tt	=> CONSONANT  | NOT_FIRST | NOT_LAST | RARE,
    :th	=> CONSONANT  | DIPHTHONG,
    :tr	=> CONSONANT  | DIPHTHONG | NOT_LAST,
    :ts	=> CONSONANT  | DIPHTHONG | NOT_FIRST,
    :tw	=> CONSONANT  | DIPHTHONG | NOT_LAST,
    :u	=> VOWEL,
    :ui	=> VOWEL | NOT_FIRST | NOT_LAST | RARE,
    :v	=> CONSONANT | NOT_LAST,
    :w	=> CONSONANT | NOT_LAST,
    :wh	=> CONSONANT | NOT_LAST,
    :x	=> CONSONANT | RARE,
    :y	=> VOWEL,
    :y	=> CONSONANT,
    :z	=> CONSONANT | RARE
  }

  # :startdoc:

  # Generate a memorable password of _length_ characters, using phonemes that
  # a human-being can easily remember.
  #
  #  pw = PhonemicPassword.generate(10)
  #
  # This would generate an ten character password such as <b>beangaipoo</b>.
  #
  #
  def self.generate(length=8)
    pw = nil
    
    # 1 out of 5 chance we start with a vowel instead of a consonant
    desired = (1 == rand(5)) ? VOWEL : CONSONANT

    pw = ""

    prev = []
    prev_ph = nil
    first = true
    last = false

    # Get an Array of all of the phonemes
    phonemes = PHONEMES.keys.map { |ph| ph.to_s }
    nr_phonemes = phonemes.size

    while pw.length < length do
    	# Get a random phoneme and its length
    	phoneme = phonemes[ rand( nr_phonemes ) ]

    	# Get its flags as an Array
    	ph_flags = PHONEMES[ phoneme.to_sym ]
    	ph_flags = [ ph_flags & CONSONANT,
    	             ph_flags & VOWEL,
    	             ph_flags & DIPHTHONG,
    	             ph_flags & NOT_FIRST,
    	             ph_flags & NOT_LAST,
    	             ph_flags & RARE ]
    	
    	# Filter on the basic type of the next phoneme
    	next unless ph_flags.include? desired
      
    	# Handle the NOT_FIRST and NOT_LAST flags
    	next if first and ph_flags.include? NOT_FIRST
    	next if last and ph_flags.include? NOT_LAST
    	
    	# Don't allow us to go longer than the desired length
    	next if phoneme.length > (length - pw.length)
    	
    	# don't use the same CONSONANT DIPHTHONG twice
    	next if ph_flags.include? CONSONANT and ph_flags.include? DIPHTHONG and pw[phoneme]
    	
    	# don't repeat similar phonemes twice in a row
    	next if prev_ph and (prev_ph[phoneme] or phoneme[prev_ph])
    	
    	# Randomly reject 1 out of 4 times
    	next if ph_flags.include? DIPHTHONG and 1 == rand(4)
    	
    	# Randomly use RARE 1 out of 8 times
    	next if ph_flags.include? RARE and not 1 == rand(8)

    	# We've found a phoneme that meets our criteria
    	pw << phoneme
    	
    	# Is it going to be the last time around next time?
    	last = (length - pw.length) <= 2

    	# Is password already long enough?
    	break if pw.length >= length
    	
    	# toggle between vowels and consonants
    	desired = (desired == CONSONANT) ? VOWEL : CONSONANT

      # save the previous flags and phoneme
    	prev = ph_flags
    	prev_ph = phoneme
    	
    	# we got past the first phoneme
    	first = false
    end

    return pw
  end

end

# Display a phonemic password, if run directly.
#
if $0 == __FILE__
  puts PhonemicPassword.generate
end