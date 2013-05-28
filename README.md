AdiURLShortener
===============

A plugin for Adium to shorten long URLs automatically as you type them.

Only URLs starting with 'http' or 'https' and longer than 20 characters are shortened; URLs pointing to images are not shortened, so this plugin doesn't conflict with the awesome Adinline plugin (http://www.adiumxtras.com/index.php?a=xtras&xtra_id=7926).

Incoming URLs are not shortened, as I personally prefer to see the original messages with some rare exceptions, like image links. If you'd like to shorten those as well, adding a line to register for incoming messages in AdiURLShortener.m within installPlugin should suffice (just copy-paste and change direction to "AIFilterIncoming").
