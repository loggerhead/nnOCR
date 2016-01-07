#nnOCR
A simple English characters recognizer using 3 layers neural network.

#Installation
```bash
# Install Octave
sudo apt-get install -y octave
./install_octave_packages.sh
# Install python dependences
sudo apt-get install -y python-dev python-numpy python-scipy
sudo pip install -r requirements.txt
```

#Running
##Training
Put your training images to `nnOCR/trainer/training_dataset/` for trainning. The image should:

* Named as *label*\_*identify*.bmp. *label* is the content of image, which is used to classify.
* Size is 20*x*20 pixels

```bash
cd trainer
./main.m [iter_num] [lambda]
```

##Predict
You can start a web server to predict user uploaded images.

```bash
# start http server at `localhost:5000`
python server.py
```

Or you can just running it locally.

```bash
python predict.py IMAGE_PATH
```

NOTICE: The built-in `thetas.mat` can only used to recognize printing numbers.

##Test
```bash
python predict.py test/1.jpg
python predict.py test/2.jpg
```

#Contributors
* [wooyiuhan](https://github.com/wooyiuhan)