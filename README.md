Milonga “hands-on” workshop
===========================

 * Date: Wednesday November 25th 2015
 * Time: 14.00--17.30
 * Location: Centro Atómico Constituyentes, Buenos Aires, Argentina
 * Attendance: 25 people (approx)
 * Responsible: Germán Theler

Foreplay
--------

While waiting for some people that were having lunch, some other people were already ready for the workshop so we started to run some example cases before even introducing milonga. For those attendants that did not have a native GNU/Linux system or were not able to compile or install milonga, a virtual machine image was kindly prepared by the organizers and distributed amongst the audience. So most of the people was able to run milonga, or at least watch some who was.

We went to the source tree of the milonga code and ran

```
$ make check
```

This is the last step of the usual `configure`, `make` & `make check` that runs some example cases to test that the code was compiled correctly and runs smoothly. In the version used in the workshop (0.4.13) some windows with a post-processing view of some simple cases are shown.


Forewords and introduction
--------------------------
 
With all the people in the room, the workshop started with a slide-based presentation that can be found [in the download section of the milonga respository](https://bitbucket.org/gtheler/milonga/downloads/2015-11-25-handson-4913f17b378d.pdf). The slides were designed using Mercurial as the distributed control version system, and the commit hash of the version shown in the workshop is `4913f17b378d`. The repository of the slides is hosted on [Bitbucket](https://bitbucket.org/cites/2015-reactores-milonga) and can be openly accessed.


We introduced some facts about what is milonga (a core-level neutronic code, work in progress, designed over sound rationales, etc.). Milonga is developed using Mercurial as the distributed control version system. It is released under the terms of the GNU GPL v3. The repository can be accessed at <https://bitbucket.org/gtheler/milonga>. The main development of the code and the associated resources is contained in that location. That URL should be the first place to look for any resource associated to milonga. A document reviewing the design basis of the code was presented in the congress ENIEF 2014, where the first meeting of the group was held. The current [revision (C) of the document](https://bitbucket.org/gtheler/milonga/downloads/WA-MI-AR-14-5B44-C.pdf) is in the download section of the milonga repository.  piece of advice was given, which is “It is really worth any amount of me and effort to get away from Windows if you are doing computational science." A related topic about graphical interfaces would come up later on. We conducted a poll about the main operating systems the attendants used, i.e. the OS in which the e-mails was read. Two people used Mac, and the rest of the attendance was split in half for GNU/Linux and half for Windows. I said that earlier this year at a [conference in Argonne National Laboratory](http://www.mcs.anl.gov/petsc/petsc-20.html) the result was approx. 75% Mac, 25% GNU/Linux and two or three Windows boxes out of more than a hundred people.

We moved on into details about the logo. It can be used in pure black or transparent with an outline to refer or to illustrate works that employ milonga. Vectorial formats should be preferred, specially SVG. The logos can be found in the [doc](https://bitbucket.org/cites/2015-reactores-milonga) directory of the milonga repository. Afterwards I tried to make a joke about the logo, trying to answer if it represents a hat or a snake that ate an elephant (as in de Saint-Exupéry's “Le Petit Prince") I said that in two dimensions it is a snake but in three dimensions it is a hat. Either nobody seemed to understand the joke, or it was definitely a bad one.

We tried to explain the role played by milonga, stating that it is essentially a _glue layer_ between a mesh generator and an eigen-problem solver. This scheme is shared by most PDE solvers, which milonga is yet another one. Milonga solves either the multigroup neutron diffusion equation or a discrete ordinates approximation to the neutron transport equation. The first one is an elliptic coercive problem, which is (relatively) easy to discretize and solve. The latter one requires some numerical artifacts to overcome potential oscillations and instabilities, but of course can be also solved. The main point is that geometry and mesh generators do exist; professional post-processing tools do exist; and high-quality numerical libraries to solve a wide variety of problems (including eigenvalue problems) also do exist. Hence, there is no point in trying to re-write what other people have already written, usually better than us. 

Strictly speaking, milonga is a plugin of the wasora framework. Wasora is also hosted in Bitbucket at <https://bitbucket.org/gtheler/wasora/>. Some resources can be found at <http://www.talador.com.ar/jeremy/wasora/>. One of the main objectives of wasora is to provide a high-level access to low-level numerical routines such as GNU Scientific Library, i.e. a [syntactically-sweetened](https://en.wikipedia.org/wiki/Syntactic_sugar) way to ask a computer to perform a certain mathema calculation. The iconic example is the Lorenz system, that may be solved by wasora using the following input file:

```
# lorenz’ seminal dynamical system solved with wasora
PHASE_SPACE x y z
end_time = 40
# parameters that lead to chaos
sigma = 10
r = 28
b = 8/3
# initial conditions
x_0 = -11
y_0 = -16
z_0 = 22.5
# the dynamical system ( note the dots before the ’= ’ sign )
x_dot .= sigma*(y - x)
y_dot .= x*(r - z) - y
z_dot .= x*y - b*z
# write the solution to the standard output
PRINT t x y z
```

Its main features are:

 * evaluation of algebraic expressions
 * one and multi-dimensional function interpolation
 * scalars, vectors and matrices operations
 * numerical integration, differentiation and root finding of functions
 * possibility to solve iterative and/or time-dependent problems
 * adaptive integration of systems of differential-algebraic equations
 * I/O from files and shared-memory objects (with optional synchronization using semaphores)
 * execution of arbitrary code provided as shared object files
 * parametric runs using quasi-random sequence numbers to efficiently sweep a sub-space of parameter space
 * non-linear fit of scattered data to one or multi-dimensional functions
 * non-linear multidimensional optimization

Almost any single feature included in wasora was needed at least once since 2009 in one computation related to a nuclear power plant. Besides the possibility of executing arbitrary code in the form of a shared object dynamic library, wasora can be extended to perform particular calculations with plugins. A plugin for wasora is a set of fixed entry-point routines (i.e. initialization, input-file parsing, instruction execution, memory cleanup, etc.). Indeed, milonga is a wasora plugin.

Following the 70-20-10 rule (people learn 10% by reading, 20% by listening and 70% by doing), we reviewed [The wasora Real Book](http://talador.com.ar/jeremy/wasora/realbook/). It is a word game about the original [Real Book](https://en.wikipedia.org/wiki/Real_Book), and contains real examples of application in an increasing order of complexity.


We then moved on to milonga. Nowadays, it solves steady-state multigroup core-level neutronic problems. Although it can solve academic cases, test benchmarks and cases of industrial interest, the code is not mature enough for the latter group. As stated in the conclusions, help in using milonga to solve problems of the first two kinds is appreciated.

We reviewed the main point of unstructured grids: they can better approximate arbitrary geometries using the same number of cells than their structured counterparts. Then we noted that if the finite-volume method (FVM) is used, the unknowns (fluxes) are computed at the center of each cells, whilst the finite-element method (FEM) gives the unknowns at the nodes. 


Hands-on milonga
----------------

The first thing to do is to execute milonga with an argument `-v` (or `--version`, as milonga follows the [POSIX recommendations](http://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html)). It should give something like this:

```
$ milonga -v
milonga 0.4.18  (deab1b33a29a 2015-11-24 22:22 -0300)
free nuclear reactor core analysis code

 rev hash deab1b33a29ad05da8a015b631dd1dcdc72225ad
 last commit on 2015-11-24 22:22 -0300 (rev 239)
 compiled on 2015-11-24 23:01:04 by gtheler@ralph (linux-gnu x86_64)
 with gcc (Debian 4.9.2-10) 4.9.2 using -O2 linked against
  SLEPc Release Version 3.6.2, Nov 03, 2015
  Petsc Release Version 3.6.2, Oct, 02, 2015  arch-linux2-c-opt
 running on Linux 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1+deb8u3 (2015-08-04) x86_64
 4  Intel(R) Core(TM) i5-3317U CPU @ 1.70GHz


 milonga is copyright (c) 2010-2015 jeremy theler
 licensed under GNU GPL version 3 or later.
 milonga is free software: you are free to change and redistribute it.
 There is NO WARRANTY, to the extent permitted by law.


----------          ----------          -------      ----    
wasora 0.4.20  (8c90e2cdbbc4 2015-11-18 08:25 -0300)
wasora's an advanced suite for optimization & reactor analysis

 rev hash 8c90e2cdbbc42979082d7a2025539d5da297440e
 last commit on 2015-11-18 08:25 -0300 (rev 174)

 compiled on 2015-11-24 15:16:25 by gtheler@ralph (linux-gnu x86_64)
 with gcc (Debian 4.9.2-10) 4.9.2 using -O2 and linked against
  GNU Scientific Library version 1.16
  GNU Readline version 6.3
  SUNDIALs Library version 2.5.0


 wasora is copyright (C) 2009-2015 jeremy theler
 licensed under GNU GPL version 3 or later.
 wasora is free software: you are free to change and redistribute it.
 There is NO WARRANTY, to the extent permitted by law.
$
```

The milonga version reported is 0.4.18. The zero indicates that there is no formal release (because the code is not yet as clean as expected and a lot of documentation is missing). The four is the number of major rewritings of the wasora API. The last number gets incremented with commit to the milonga repository. The same goes for the wasora version. Nevertheless, the main point is the revision hash which is unique to each repository snapshot, i.e. due to the distributed nature of the version control system there may be two source trees with the same version number but their revision hash will be different and their histories completely traceable.

We created a new directory called `2015-workshop` in which the examples shown in the beamer would be written from scratch in order to illustrate all the steps and the rationale behind each keyword needed by milonga. I asked what is the first thing one engineering ought to do after creating an empty directory where to work with plain-text input files. Chacho said “create a README,” which is a very good proposal but it should be step number two. The first step is to initialize the directory as a repository of a distributed control version system such as [Git](http://www.git-scm.com/) or [Mercurial](https://www.mercurial-scm.org/). We chose Mercurial, so we issued

```
$ cd 2015-workshop
$ hg ini
$
```

In fact, this repository is what you have cloned if you are reading this. And this text is step #2, the `README` file. Actually, it is `README.md` because it is a [markdown](http://daringfireball.net/projects/markdown/)-formatted text, which can be converted into a variety of other formats using for example [Pandoc](http://pandoc.org/). 

We chose to solve a one-dimensional slab with uniform XS as the first case. Even though a slab can be solved using structured grids, we chose to use [Gmsh](http://www.geuz.org/gmsh/) to generate the geometry and the mesh.

We started to edit the geometry using a mixture of Gmsh's graphical interface and the edition of the `.geo` file containing the geometry. The resulting geometry file and mesh file of this case are `slab-refinado.geo` and `slab-refinado.msh` respectively. _The detailed instructions to generate these files from scratch should be added to this document._

We then built the input file `slab-refinado.mil` that is the one milonga reads and executes. It looks something like this:

```
MESH FILE_PATH slab-refinado.msh
MILONGA_PROBLEM GROUPS 1 DIMENSIONS 1
MATERIAL fuel D 1    nuSigmaF 0.12 SigmaA 0.1

PHYSICAL_ENTITY NAME left  BC null
PHYSICAL_ENTITY NAME right BC null

MILONGA_STEP
PRINT "\# keff = " %.8f keff %.2f phi1(50)
PRINT_FUNCTION phi1
```

Some design decisions were explained during the construction of this file. Some of [Eric Raymond's 17 UNIX Rules](https://en.wikipedia.org/wiki/Unix_philosophy#Eric_Raymond.E2.80.99s_17_Unix_Rules) were explained. A discussion about using the terminal instead of GUIs that ended in my personal remark that if one avoids hacking at the terminal will in the end loose a lot of stuff, much like one does if decides to stick to Windows. Something like going to an opera house and asking for latin music.

The case is run with the following result:

```
$ milonga slab-refinado.mil 
# keff =        1.18830005      1.57
4.611041e+00    2.276228e-01
1.349294e+01    6.477179e-01
2.171956e+01    9.920063e-01
2.933925e+01    1.252014e+00
3.639678e+01    1.429087e+00
4.293363e+01    1.530668e+00
4.898821e+01    1.567392e+00
5.459611e+01    1.551015e+00
5.979027e+01    1.493068e+00
6.460123e+01    1.404067e+00
6.905725e+01    1.293131e+00
7.318452e+01    1.167861e+00
7.700730e+01    1.034385e+00
8.054804e+01    8.974997e-01
8.382756e+01    7.608451e-01
8.686512e+01    6.270957e-01
8.967859e+01    4.981392e-01
9.228448e+01    3.752386e-01
9.469812e+01    2.591704e-01
9.693370e+01    1.503412e-01
9.900433e+01    4.888200e-02
$
```

By default, milonga solves the neutron diffusion equation using finite volumes. These settings can be changed either using keywords in the input file or using commandline arguments. To solve the same slab using finite elements:

```
$ milonga slab-refinado.mil --elements
# keff =        1.18823886      1.57
0.000000e+00    5.674904e-09
1.000000e+02    -3.534358e-09
9.222083e+00    4.496737e-01
1.776379e+01    8.336271e-01
2.567532e+01    1.136701e+00
3.300317e+01    1.355555e+00
3.979039e+01    1.494730e+00
4.607687e+01    1.563372e+00
5.189956e+01    1.572760e+00
5.729266e+01    1.534605e+00
6.228789e+01    1.459992e+00
6.691458e+01    1.358791e+00
7.119993e+01    1.239404e+00
7.516912e+01    1.108734e+00
7.884547e+01    9.722701e-01
8.225060e+01    8.342540e-01
8.540451e+01    6.978586e-01
8.832573e+01    5.653760e-01
9.103144e+01    4.383882e-01
9.353753e+01    3.179181e-01
9.585872e+01    2.045582e-01
9.800867e+01    9.857591e-02
$
```


Unfortunately the virtual machine distributed amongst the audience did not have a full installation of [Gnuplot](http://www.gnuplot.info/) so it was difficult to draw the results. 

_The detailed explanation and different options taken to converge to this input from scratch should be added to this document._


The available commandline options are:

```
$ milonga -h
usage: milonga [options] inputfile [replacement arguments]

  -p library            load wasora plugin named library
 --plugin library       before reading the input file

  -d, --debug           start in debug mode
      --no-debug        ignore standard input, avoid debug mode
  -l, --list            list defined symbols and exit
  -h, --help            display this help and exit
  -v, --version         display version information and exit

 instructions are read from standard input if "-" is passed as inputfile

milonga usage:
  --diffusion           use the diffusion formulation
  --s2                  use the discrete ordinates S2 formulation
  --s4                  use the discrete ordinates S4 formulation
  --s6                  use the discrete ordinates S6 formulation
  --s8                  use the discrete ordinates S8 formulation
                        (they override the MILONGA_PROBLEM FORMULATION keyword))
  --elements            use a finite-elements-based spatial discretization scheme
  --volumes             use a finite-volumes-based spatial discretization scheme
                        (both override the MILONGA_PROBLEM SCHEME keyword))
  --largest             solve R phi = 1/k F phi (largest eigenvalue spectrum)
  --smallest            solve F phi =  k  R phi (smallest eigenvalue spectrum)
                        (both override the MILONGA_SOLVER SPECTRUM keyword))
  --petsc_opt <option[=argument]>
                        pass "-option argument" directly to PETSc/SLEPc, e.g.
    $ milonga slab.was --petsc_opt malloc_dump --petsc_opt eps_type=gd

  command line options override keywords given in the input, e.g.
    $ milonga slab.was --elements --largest --slecp_opt st_type=sinvert
  uses finite elements, largest eigenvalue formulation and shift & invert transform
  even if the input contains
    MILONGA_PROBLEM SCHEME volumes
    MILONGA_SOLVER SPECTRUM smallest_eigenvalue ST_TYPE shift

```


A coffee break followed.


After the break
---------------

The next problem of interest is a reflected slab using two groups of energy in order to illustrate the effect known as _thermal shoulder_. A geometry file called `slab-reflected.geo` and an input file called `slab-reflected.mil` are provided in this repository to illustrate the point. It can handle optional commandline arguments (apart from the ones that milonga recognize, as shown in `milonga -h`) that expands into `$1` and `$2` within the input and can be used to define the formulation (diffusion, s2, s4, etc.) and/or the discretization scheme (volumes or elements).

_A detailed explanation of this input should be added to this document._

```
$ milonga slab-reflected.mil 
diffusion volumes       keff =  0.99876099      incognitas =    78
$ milonga slab-reflected.mil --s2
diffusion volumes       keff =  0.99992139      incognitas =    156
$ milonga slab-reflected.mil s2
s2 volumes      keff =  0.99992139      incognitas =    156
$ milonga slab-reflected.mil s4
s4 volumes      keff =  1.00067075      incognitas =    312
$ milonga slab-reflected.mil s6 elements
s6 elements     keff =  0.99964645      incognitas =    480
$
```

Milonga generates two files with extension `.sng` that can be converted into a PNG representation of the removal and fission matrices with the tool [SNG](http://sng.sourceforge.net/).

An example input in the `examples` subidrectory of the milonga repository is called `2dpwr.mil`. It solves the 2D IAEA PWR Benchmark in _a-la-milonga_ way. Some details of the problem and its solution can be found in this [paper](http://downloads.hindawi.com/journals/stni/2013/641863.pdf), in this [monograph](http:/www.talador.com.ar/jeremy/milonga/doc/imef-2013-12-15.pdf) and in this [link](http://talador.com.ar/jeremy/wasora/milonga/realbook/._realbook002.html). In the workshop we went through each line of the input `2dpwr.mil`, explaining its meaning. This input can read optional arguments in the commandline that select whether a structured or unstructured grid is used, whether finite volumes or elements are used and a refinement mesh factor $c$ (the higher the $c$ the finer the grid). Depending on these optional arguments, the main input `2dpwr.mil` includes either `2dpwr_structured.mil` or `2dpwr_unstructured.mil`, and they both include `2dpwr_materials.mil`. After running the input, the post-processing can be performed with [Gmsh](http://www.geuz.org/gmsh/) (files `*.pos`) and/or with [Paraview](http://www.paraview.org/) (files `*.vtk`). These post-processing files are named `2dpwr-`_mesh_`-`_scheme_`-`_c_, for example `2dpwr-unstructured-elements-5` or `2dpwr-structured-volumes-3`. There is also a [markdown](http://daringfireball.net/projects/markdown/)-formatted text with the same name but extension `.txt` that contain some debug information. These files were generated by milonga because the keyword `MILONGA_DEBUG` was given in the input.

```
$ milonga 2dpwr.mil
keff =  1.0293135495  ( structured volumes, lc =  3.33333 ,  5202 x 5202 ,  0.01 0.14 1.15  secs )
$ milonga 2dpwr.mil unstructured
keff =  1.0301546689  ( unstructured volumes, lc =  3.33333 ,  5792 x 5792 ,  0.01 0.02 2.75  secs ) 
$ milonga 2dpwr.mil unstructured
keff =  1.0301546689  ( unstructured volumes, lc =  3.33333 ,  5792 x 5792 ,  0.01 0.03 2.82  secs ) 
$ milonga 2dpwr.mil
keff =  1.0293135495  ( structured volumes, lc =  3.33333 ,  5202 x 5202 ,  0.01 0.14 1.13  secs ) 
$ milonga 2dpwr.mil unstructured
keff =  1.0301546689  ( unstructured volumes, lc =  3.33333 ,  5792 x 5792 ,  0.01 0.02 2.57  secs ) 
$ milonga 2dpwr.mil unstructured volumes
keff =  1.0301546689  ( unstructured volumes, lc =  3.33333 ,  5792 x 5792 ,  0.01 0.02 2.56  secs ) 
$ milonga 2dpwr.mil unstructured elements
keff =  1.0296658715  ( unstructured elements, lc =  3.33333 ,  6002 x 6002 ,  0.00 0.14 3.36  secs ) 
$ milonga 2dpwr.mil unstructured elements 3
keff =  1.0296658715  ( unstructured elements, lc =  3.33333 ,  6002 x 6002 ,  0.00 0.15 3.44  secs ) 
$ milonga 2dpwr.mil unstructured elements 4
keff =  1.0296351933  ( unstructured elements, lc =  2.5 ,  9828 x 9828 ,  0.00 0.26 7.27  secs ) 
$ milonga 2dpwr.mil unstructured elements 5
keff =  1.0296233755  ( unstructured elements, lc =  2 ,  15890 x 15890 ,  0.00 0.41 15.49  secs ) 
```


We then reviewed the post-processing views of the square that appears after performing the `make check` step: a square solved using both finite volumes and elements over both structured and unstructured grids. We then re-run the example input `3dshape.mil` that reads from the commandline the name of the mesh and solves a diffusion problem with uniform XSs over that grid. We used the [Stanford Bunny](https://en.wikipedia.org/wiki/Stanford_bunny) as a test case.

Conclusions
-----------

