PY = python3
VENV = venv

ifeq ($(OS), Windows_NT)
	BIN=$(VENV)/Scripts
	PY=python3.exe
else
	BIN=$(VENV)/bin
endif


all: lint test

$(VENV): requirements.txt requirements-dev.txt setup.py
	$(PY) -m venv $(VENV)
	$(BIN)/python3 -m pip install --upgrade -r requirements.txt
	$(BIN)/python3 -m pip install --upgrade -r requirements-dev.txt
	$(BIN)/python3 -m pip install -e .
	touch $(VENV)

test: $(VENV)
	$(BIN)/python3 -m pytest
.PHONY: test

lint: $(VENV)
	$(BIN)/python3 -m flake8
.PHONY: lint

release: $(VENV)
	$(BIN)/python3 setup.py sdist bdist_wheel
	$(BIN)/twine upload dist/*
.PHONY: release

clean:
	rm -rf build dist *.egg-info
	rm -rf $(VENV)
	find . -type f -name *.pyc -delete
	find . -type d -name __pycache__ -delete
	# coverage
	rm -rf htmlcov .coverage
.PHONY: clean
