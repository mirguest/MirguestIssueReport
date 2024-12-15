class Config:
    # Training parameters
    num_epochs = 200
    batch_size = 64
    learning_rate = 0.0002
    beta1 = 0.5  # Beta1 for Adam optimizer
    
    # Model parameters
    latent_dim = 100  # Size of noise vector
    ngf = 64  # Size of feature maps in generator
    ndf = 64  # Size of feature maps in discriminator
    nc = 3    # Number of channels in the training images
    image_size = 64  # Size of training images
    
    # Data parameters
    data_path = './data'  # Path to dataset
    workers = 2  # Number of data loading workers
    
    # Logging parameters
    sample_interval = 100  # How often to save sample outputs
    checkpoint_interval = 50  # How often to save model checkpoints
    
    # Paths
    checkpoint_dir = './checkpoints'
    samples_dir = './samples'
