# vertica-toolbox
A Docker image collecting Jupyter Notebook, Superset, and other applications for Vertica users.

The overall goal is to provide a Docker image that enables Jupyter notebook with Python 3 and Vertica Python driver, plus a number of useful toolsets, popular data science libraries, and visualization add-ons.  Users could then install and run the Docker image for easy setup of a Jupyter notebook environment on top of Vertica.

Current image contents include:
- Jupyter Notebook
- Python 3 engine (using conda package management)
- Common data science libraries for Python: pandas, matplotlib, scipy, seaborn, scikit-learn, scikit-image, sympy, cython, patsy, statsmodel, cloudpickle, dill, numba, bokeh, vincent, beautifulsoup, xlrd
- Vertica client: vertica-python
- Visualization: plot.ly, Dash, Superset
- Machine learning with Vertica-ML-Python

Some example notebooks are included to demonstrate Vertica connectivity, functions, and visualizations in Python.

Open an issue here if you find any bugs or would like to suggest any additional features.

### Docker Cloud build

https://cloud.docker.com/swarm/bryanherger/repository/docker/bryanherger/vertica-toolbox/general
