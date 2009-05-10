This directory contains my code version 2 for the Ruby Quiz No 74 
( http://www.rubyquiz.com/).

It generates text with Markov Chains of any order. Because the matrix of a 
Markov chain for native language tests is sparse, the chain is stored in a 
hash of hashes for better memory usage.

There are some open issues i think, but i did not had the time to implement
them
	- better performance of the MarkovChain#rand() method
	- and of course there are a lot of open issues with respect to natural 
      language processing, the code does not produce grammatical valid 
      sentences, no quotes, no comma, etc.

I programmed it to learn Ruby and to improve my coding skills, because i only 
have 2,3 weeks of experience with Ruby. I bought the "Programming Ruby" book 
by Dave Thomas et. al. and started to read it two weeks and two days ago and 
i used it a lot the last 48 hours. I think there are some parts of the code 
where there are better solutions or could be better expressed in a more 
"rubyish" way.

I used Java and Perl a lot in the last years and i will use Ruby now instead 
of Perl. I can remember my experiences with hashes of hashes in Perl. This was 
awkward and often a pain. And on friday as i started coding for this quiz i 
suddenly realized that i had none of this issues in Ruby. Wow ! Because i 
know the functional language Haskell i am used to iterators, map's, lambda's 
etc. and i tried to use iterators and block in the program, but i think i 
have to get more experience here in Ruby.

If you have any comments, i will be glad to receive and answer them.

Extract the archive

$ tar xzf joern_dinkla_quiz_74.tar.gz

Call the program and print the command line syntax.

$ cd net.dinkla.ruby.quiz.74/lib
$ ruby main-markov-chain.rb --help

Best regards,

Joern Dinkla, <joern@dinkla.net>, J&ouml;rn Dinkla

