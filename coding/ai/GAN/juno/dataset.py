import os
import torch
from torch.utils.data import Dataset, DataLoader
from torchvision import transforms, datasets
from config import Config

def get_dataloader():
    """Create the data loader for training"""
    # Create transform pipeline
    transform = transforms.Compose([
        transforms.Resize(Config.image_size),
        transforms.CenterCrop(Config.image_size),
        transforms.ToTensor(),
        transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5)),
    ])
    
    # Create dataset
    # Note: You'll need to replace this with your actual dataset
    # This example uses ImageFolder which expects images organized in folders by class
    dataset = datasets.ImageFolder(root=Config.data_path, transform=transform)
    
    # Create the dataloader
    dataloader = DataLoader(dataset,
                          batch_size=Config.batch_size,
                          shuffle=True,
                          num_workers=Config.workers,
                          pin_memory=True)
    
    return dataloader

def create_directories():
    """Create necessary directories for saving checkpoints and samples"""
    os.makedirs(Config.checkpoint_dir, exist_ok=True)
    os.makedirs(Config.samples_dir, exist_ok=True)
    os.makedirs(Config.data_path, exist_ok=True)
