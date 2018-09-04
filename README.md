# Convex Diffusion


## What is it?

`convex_diffusion` is a convex optimization framework for generating asymmetric diffusion encoding gradient waveforms for high-resolution magnetic resonance diffusion imaging. 
It solves a quadratic optimization problem with convex constraints using semidefinite programming yielding optimized asymmetric spin echo sequences with short echo times that are robust regarding concomitant field effects and motion. The framework is written in MATLAB R2017a.

## Installation
Install from Github source:

### Windows:
```
git clone https://github.com/alen-mujkanovic/convex_diffusion.git
git clone https://github.com/yalmip/YALMIP
xcopy /s .\convex_diffusion\operators\@sdpvar\*.* .\YALMIP\@sdpvar
```
### Linux:
```
git clone https://github.com/alen-mujkanovic/convex_diffusion.git
git clone https://github.com/yalmip/YALMIP
cp -a ./convex_diffusion/operators/@sdpvar/. ./YALMIP/@sdpvar
```


## Example

If you want to run the example, you require MATLAB 2017a and will also have to install:
- **YALMIP** by Johan Löberg: https://yalmip.github.io/
and a convex solver supported by YALMIP, such as
- **CPLEX** by IBM: https://www.ibm.com/products/ilog-cplex-optimization-studio/
- **SeDuMi** from Lehigh University: http://sedumi.ie.lehigh.edu/
- **SDPT3**: https:/github.com/sqlp/sdpt3/

Alternatively, the code can be easily modified to use:
- **CVX** by CVX Research: http://cvxr.com/cvx/

## Citing

If you use `convex_diffusion` in your research, you can cite it as follows:
```bibtex
@misc{mujkanovic2018convexdiffusion,
    author = {Alen Mujkanović},
    title = {convex_diffusion},
    year = {2018},
    publisher = {GitHub},
    journal = {GitHub repository},
    howpublished = {\url{https://github.com/alen-mujkanovic/convex_diffusion}},
}
```

## References

1. Aliotta E, Wu HH, Ennis DB. Convex optimized diffusion encoding (CODE) gradient waveforms for minimum echo time and bulk motion–compensated diffusion-weighted MRI. Magn. Reson. Med. 2017;77:717–729. doi: 10.1002/mrm.26166. [[GitHub]](https://github.com/ealiotta/code-gradient-design)
2. Szczepankiewicz F, Nilsson M. Maxwell-compensated waveform design for asymmetric diffusion encoding. ISMRM Abstr. Submiss. 2018:6–9. [[GitHub]](https://github.com/jsjol/NOW/blob/master/now_maxwell_coeff.m)
3. Efberg J. YALMIP : A toolbox for modeling and optimization in MATLAB. 2004 IEEE Int. Symp. Comput. Aided Control Syst. Des. 2004:284–289. [[GitHub]](https://github.com/yalmip/YALMIP)
4. Vannesjo SJ, Dietrich BE, Pavan M, Brunner DO, Wilm BJ, Barmet C, Pruessmann KP. Field camera measurements of gradient and shim impulse responses using frequency sweeps. Magn. Reson. Med. 2014;72:570–583. doi: 10.1002/mrm.24934.
5. Stoeck CT, Von Deuster C, GeneT M, Atkinson D, Kozerke S. Second-order motion-compensated spin echo diffusion tensor imaging of the human heart. Magn. Reson. Med. 2016;75:1669–1676. doi: 10.1002/mrm.25784.
6. Nguyen C, Fan Z, Xie Y, Pang J, Speier P, Bi X, Kobashigawa J, Li D. In vivo diffusion-tensor MRI of the human heart on a 3 tesla clinical scanner: An optimized second order (M2) motion compensated diffusion-preparation approach. Magn. Reson. Med. 2016;76:1354–1363. doi: 10.1002/mrm.26380.
