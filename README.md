# Wireshark RTP TTML disector

This plugin for the [Wireshark protocol analyzer](https://www.wireshark.org/) provides the means to verify that an implementation is correctly producing the required header fields for [RFC 8759 TTML RTP](https://datatracker.ietf.org/doc/rfc8759/) packets.

## Installation

### Requirements

*   [Wireshark](https://www.wireshark.org/)

### Steps

1.  Ensure your Wireshark works with Lua plugins - "About Wireshark" should say it is compiled with Lua.
2.  Install this dissector in the proper plugin directory - see "About Wireshark/Folders" to see Personal and Global plugin directories.
3.  After putting this dissector in the proper folder, "About Wireshark/Plugins" should list "ttml.lua". You may need to re-start wireshark.

### Usage

1.  In Edit -> Preferences, under "Protocols", find ttml and set the dynamic payload type to match the RTP stream to be analysed.
2.  Capture packets of an RTP stream.
3.  Right click a TTML packet -> "Decode As...", set the "Current" value to "RTP".
4.  You will now see the TTML payload headers decoded within the RTP packets.

## Limitations
This plugin only fully supports UTF-8. While the header fields will always be decoded correctly, it will not correctly decode UTF-16 documents.

## Contributing

Whilst we do not expect contributions to this plugin, we would appreciate reporting of any bugs via GitHub's Issues. We will endeavour to investigate and resolve issues as soon as possible. Any contributions will be considered on a case-by-case basis.

## License

See [LICENSE](LICENSE)
