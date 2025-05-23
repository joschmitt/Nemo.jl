using Documenter, Nemo, AbstractAlgebra

DocMeta.setdocmeta!(Nemo, :DocTestSetup, :(using Nemo); recursive = true)
DocMeta.setdocmeta!(AbstractAlgebra, :DocTestSetup, AbstractAlgebra.doctestsetup(); recursive = true)

makedocs(
         format = Documenter.HTML(),
         sitename = "Nemo.jl",
         modules = [Nemo, AbstractAlgebra],
         clean = true,
         checkdocs = :none,
         doctest = true,
         pages    = [
                     "index.md",
                     "about.md",
                     "types.md",
                     "constructors.md",
                     "Rings" => [
                                 "integer.md",
                                 "polynomial.md",
                                 "mpolynomial.md",
                                 "series.md",
                                 "puiseux.md",
                                 "residue.md",
                                ],
                     "Fields" => [
                                  "fraction.md",
                                  "rational.md",
                                  "algebraic.md",
                                  "exact.md",
                                  "complex.md",
                                  "real.md",
                                  "arb.md",
                                  "acb.md",
                                  "gfp.md",
                                  "finitefield.md",
                                  "ff_embedding.md",
                                  "numberfield.md",
                                  "padic.md",
                                  "qadic.md",
                                 ],
                     "matrix.md",
                     "factor.md",
                     "misc.md",
                     "Developer" => [
                                     "developer/introduction.md",
                                     "developer/conventions.md",
                                     "developer/typesystem.md",
                                     "developer/parents.md",
                                     "developer/interfaces.md",
                                     "developer/topics.md",
                                    ]
                    ]
        )

deploydocs(
           repo   = "github.com/Nemocas/Nemo.jl.git",
           target = "build"
          )
