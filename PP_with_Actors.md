Document
================

**Task**

Implementing ActorSpace programming model in Erlang


**Motivating Example**

- Two-sided matching based on attributes

Given two types of agents A, B, each one is equipped some attributes
`a_i` representing individual aspects, and some preferences `p_i`
denoting its interests of characteristics of potential partners.  A
matching M is a one-to-one association between A and B.

Traditional, desired properties of two-sided matching:

	- stability: there exists no pair (a,b) such that a prefer b over M(a) and vice versa
	- optimality: every element is matched

[random](http://www.prismmodelchecker.org/papers/coopmas12.pdf) two-sided matching based on ranked list of identifier



- [Car manufactures](http://www.sciencedirect.com/science/article/pii/S0743731584710604) example in ActorSpace

**Research questions**

- ways to introduce probability to actor space

- similar to the idea of probabilistic broadcast, when an actor is forwared a
  message from CoordinatorActorSpace, it can process the message with a probability p

- design decision:
  if an actor rejects a message, it can forward that message to another actor in the same space?



**Background**

[Introductory paper](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/fose-icse2014.pdf)

- the purpose of ordinary program is to be excuted
- the purpose of probabilistic program is to speficy probability distribution for program variables
- the meaning of probabilistic program is the expected return value
- probabilistic inference is the problem of computing the distribution
  which was implicitly specified by a probabilistic program
- lift the burden of probabilistic modelling and inference for programmers who are not familiar with probability theory and machine learning techniques
- usally the probabilistic model is Bayesian networks
- two main approach to inference: static vs dynamic


**Related works**

- [Church](https://web.stanford.edu/~ngoodman/papers/churchUAI08_rev2.pdf) is a LISP extension for probabilistic programming.
  The key idea of Church is memorization
- [PMaude](http://www.sciencedirect.com/science/article/pii/S1571066106002672)
  is a framework for modelling and verifying concurrent systems based
  on theory rewrite modules.
- [Problog](https://dtai.cs.kuleuven.be/problog/index.html) is a probability version of ProLog
- [PScala](https://github.com/Morpheusss/ProbabilisticProgramming) is a prototype implementation of probability model in Scala.
- [Probabilistic Linda](https://pdfs.semanticscholar.org/7218/93ecab62055ff21f2e338ad3f046f1a511a3.pdf)
- [Probabilistic Klaim](https://link.springer.com/chapter/10.1007/978-3-540-24634-3_11)
- [Stochastic Klaim](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.523.7487&rep=rep1&type=pdf)
- [ActorSpace](http://osl.cs.illinois.edu/media/papers/agha-1993-ppopp-actorspaces.pdf)
is a programming model based on actors which supports open systems.
It unify two scalable models, namely Linda and Actor to come up with
one-to-many communication style for actors.
- [Probabilistic Broadcast protocol](https://link.springer.com/chapter/10.1007/1181476412) consider several cases of uncertainty

	-- Gossiping: the source node broadcast a message to all neighbors. These nodes decide whether or not to forward the recived message to all of their neighbors with a probability psend

	-- Gossiping with collision: if more than one neighbors send their messages to the same node, then this node is considered receiving noise and will not act

	-- Lossy Channel: The connection between two nodes might be subject to unrealibility. A buffer is introduced between any two nodes, buffering a message with a probability preceive. Therefore, a node forwards message only if one of its in-link buffer has a message

	-- [PRISM model](http://www.prismmodelchecker.org/casestudies/prob_broadcast.php)

**Tools**

Simulation based probabilistic programming

- [Church](http://projects.csail.mit.edu/church/wiki/Church)
- [PVesta](http://maude.cs.uiuc.edu/tools/pvesta/) integrates PMaude
- [PScala](https://github.com/Morpheusss/ProbabilisticProgramming)

Logic based probabilistic programming

- [Problog](https://dtai.cs.kuleuven.be/problog/index.html)

Probabilistic model checkers

- [PRISM](http://www.prismmodelchecker.org/)
- [Storm](http://www.stormchecker.org/)
