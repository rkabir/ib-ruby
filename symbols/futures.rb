#
# Copyright (C) 2006 Blue Voodoo Magic LLC.
#
# This library is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301 USA
#


# The Futures constant is currently for testing purposes. It guesses the front month
# currency future using a crude algorithm that does not take into account expiry/rollover day.
# This will be valid most of the time, but near/after expiry day the next quarter's contract
# takes over as the volume leader.
#
#
# Note that the :description field is particular to ib-ruby, and is NOT part of the standard TWS API.
# It is never transmitted to IB. It's purely used clientside, and you can store any arbitrary string that
# you may find useful there.
#

$:.push(File.dirname(__FILE__) + "/../")

require 'ib'
require 'datatypes'

module IB
  module Symbols

    # Get the next valid quarter month >= today, for finding the
    # front month of quarterly futures.
    #
    # N.B. This will not work as expected near/after expiration during that month, as
    # volume rolls over to the next quarter even though the current month is still valid!
    #


    def self.next_quarter_month(time)
      sprintf("%02d", [3, 6, 9, 12].find{|month| month >= time.month })
    end

    def self.next_quarter_year(time)
      if self.next_quarter_month(time).to_i < time.month
        time.year + 1
      else
        time.year
      end
    end

    def self.next_expiry(time)
      "#{ self.next_quarter_year(time) }#{ self.next_quarter_month(time) }"
    end

    Futures =
     {
      :es => Datatypes::Contract.new({
                                       :symbol => "ES",
                                       :expiry => self.next_expiry(Time.now),
                                       :exchange => "GLOBEX",
                                       :currency => "USD",
                                       :sec_type => Datatypes::Contract::SECURITY_TYPES[:future],
                                       :multiplier => 50,
                                       :description => "E-Mini S&P 500"
                                     }),

      :gbp => Datatypes::Contract.new({
                                       :symbol => "GBP",
                                       :expiry => self.next_expiry(Time.now),
                                       :exchange => "GLOBEX",
                                       :currency => "USD",
                                       :sec_type => Datatypes::Contract::SECURITY_TYPES[:future],
                                       :multiplier => 62500,
                                       :description => "British Pounds"
                                     }),
      :eur => Datatypes::Contract.new({
                                       :symbol => "EUR",
                                       :expiry => self.next_expiry(Time.now),
                                       :exchange => "GLOBEX",
                                       :currency => "USD",
                                       :sec_type => Datatypes::Contract::SECURITY_TYPES[:future],
                                       :multiplier => 12500,
                                       :description => "Euro FX"
                                     }),
      :jpy => Datatypes::Contract.new({
                                       :symbol => "JPY",
                                       :expiry => self.next_expiry(Time.now),
                                       :exchange => "GLOBEX",
                                       :currency => "USD",
                                       :sec_type => Datatypes::Contract::SECURITY_TYPES[:future],
                                       :multiplier => 12500000,
                                       :description => "Japanese Yen"
                                     }),
      :hsi => Datatypes::Contract.new({
                                       :symbol => "HSI",
                                       :expiry => self.next_expiry(Time.now),
                                       :exchange => "HKFE",
                                       :currency => "HKD",
                                       :sec_type => Datatypes::Contract::SECURITY_TYPES[:future],
                                       :multiplier => 50,
                                       :description => "Hang Seng Index"
                                     })
    }
  end
end
