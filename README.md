# Hijri UmmAlqura

TODO: Write a gem description

## Installation


First, make sure you have Ruby installed.

**On a Mac**, open `/Applications/Utilities/Terminal.app` and type:

    ruby -v

If the output looks something like this, you're in good shape:

    ruby 2.0.0p353 (2013-11-22 revision 43784) [x86_64-darwin12.1.0]

If the output looks more like this, you need to [install Ruby][ruby]:
[ruby]: http://www.ruby-lang.org/en/downloads/

    ruby: command not found

**On Linux**, for Debian-based systems, open a terminal and type:

    sudo apt-get install ruby-dev

or for Red Hat-based distros like Fedora and CentOS, type:

    sudo yum install ruby-devel

(if necessary, adapt for your package manager)

**On Windows**, you can install Ruby with [RubyInstaller][].
[rubyinstaller]: http://rubyinstaller.org/

After that you can install hijri_umm_alqura by doing one of the following:

**1-** Add this line to your application's Gemfile:

    gem 'hijri_umm_alqura'

And then execute:

    $ bundle

**2-** Or install it yourself as:

    $ gem install hijri_umm_alqura

## Usage

#### Start with a new hijri date:
 
  hijridob = HijriUmmAlqura::Hijri.new(1433,11,30)

#### Get the julian date: 
  
  hijridob.jd 
  
#### Get the julian date: 
  
 hijridob.gd
 
####Add Days - Weeks - Months - Years to current hijri date:

 hijridob.add(10,'d')
 
 hijridob.add(4,'m')
 
 hijridob.add(2,'y')

#### Get how many days in current month:
 
 hijridob.days_in_month

### You can use it directly

#### convert from gregorian to julian 
  
  HijriUmmAlqura.gd_to_jd(1960, 3, 1)
  
#### convert from julian to gregorian
  
  HijriUmmAlqura.jd_to_gd(2456641.5)
  
#### convert from hijri to gregorian 
  
 HijriUmmAlqura.hd_to_gd(1388, 5, 17)
 
#### convert from gregorian to hijri

 HijriUmmAlqura.gd_to_hd(1970, 11, 18)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
