#!/usr/bin/env python

#import requests, 
import argparse
import cmd2

#parser = argparse.ArgumentParser()
#parser.add_argument("-r", "--role", help="display role of current user", action='store_true')
#args = parser.parse_args()
#if args.role:
    #print("Role now displays properly")
"""
class firstapp(cmd2.Cmd):
    def __init__(self):
        shortcuts = cmd2.DEFAULT_SHORTCUTS
        shortcuts.update({'&': 'speak'})
        super().__init__(multiline_commands=['orate'],shortcuts=shortcuts)
        del cmd2.Cmd.do_shell           # disable access to the shell command, disallowing using OS
                                        # commands from within the app

        # Make maxrepeats settable at runtime
        self.maxrepeats = 3
        self.add_settable(cmd2.Settable('maxrepeats', int, 'max repetitions for speak command', self))    
        """ A simple cmd2 application."""

    speak_parser = cmd2.Cmd2ArgumentParser()
    speak_parser.add_argument('-p', '--piglatin',action='store_true', help='atinLay')
    speak_parser.add_argument('-s', '--shout',action='store_true', help='N00B EMULATION')
    speak_parser.add_argument('-r', '--repeat',type=int, help='output [n] times')
    speak_parser.add_argument('words', nargs='+', help='words to say')

    @cmd2.with_argparser(speak_parser)
    def do_speak(self, args):
        """Repeats what you tell me to."""
        words = []
        for word in args.words:
            if args.piglatin:
                word = '%s%say' % (word[1:], word[0])
            if args.shout:
                word = word.upper()
            words.append(word)
        repetitions = args.repeat or 1
        for _ in range(min(repetitions, self.maxrepeats)):
            # .poutput handles newlines, and accomodates redirection too
            self.poutput(' '.join(words))

    do_orate = do_speak



if __name__ == '__main__':
    import sys
    c = firstapp()
    sys.exit(c.cmdloop())
"""
