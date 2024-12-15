import os
import torch
import torch.nn as nn
import torch.optim as optim
import torchvision.utils as vutils
from tqdm import tqdm
import matplotlib.pyplot as plt

from models import Generator, Discriminator, weights_init
from dataset import get_dataloader, create_directories
from config import Config

def train():
    # Set random seed for reproducibility
    torch.manual_seed(42)
    
    # Create necessary directories
    create_directories()
    
    # Set device
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    
    # Create the generator and discriminator
    netG = Generator(Config.latent_dim, Config.ngf, Config.nc).to(device)
    netD = Discriminator(Config.ndf, Config.nc).to(device)
    
    # Apply custom weights initialization
    netG.apply(weights_init)
    netD.apply(weights_init)
    
    # Create the optimizers
    optimizerD = optim.Adam(netD.parameters(), lr=Config.learning_rate, betas=(Config.beta1, 0.999))
    optimizerG = optim.Adam(netG.parameters(), lr=Config.learning_rate, betas=(Config.beta1, 0.999))
    
    # Initialize BCELoss function
    criterion = nn.BCELoss()
    
    # Create fixed noise for visualization
    fixed_noise = torch.randn(64, Config.latent_dim, 1, 1, device=device)
    
    # Get the dataloader
    dataloader = get_dataloader()
    
    # Lists to keep track of progress
    G_losses = []
    D_losses = []
    
    print("Starting Training Loop...")
    for epoch in range(Config.num_epochs):
        pbar = tqdm(enumerate(dataloader), total=len(dataloader))
        for i, (real_images, _) in pbar:
            ############################
            # (1) Update D network: maximize log(D(x)) + log(1 - D(G(z)))
            ###########################
            netD.zero_grad()
            
            # Format batch
            real_images = real_images.to(device)
            b_size = real_images.size(0)
            label_real = torch.ones(b_size, device=device)
            label_fake = torch.zeros(b_size, device=device)
            
            # Forward pass real batch through D
            output_real = netD(real_images)
            errD_real = criterion(output_real, label_real)
            
            # Generate fake images
            noise = torch.randn(b_size, Config.latent_dim, 1, 1, device=device)
            fake_images = netG(noise)
            
            # Classify fake
            output_fake = netD(fake_images.detach())
            errD_fake = criterion(output_fake, label_fake)
            
            # Add gradients from all-real and all-fake batches
            errD = errD_real + errD_fake
            errD.backward()
            
            # Update D
            optimizerD.step()
            
            ############################
            # (2) Update G network: maximize log(D(G(z)))
            ###########################
            netG.zero_grad()
            
            # Since we just updated D, perform another forward pass of fake batch through D
            output_fake = netD(fake_images)
            errG = criterion(output_fake, label_real)  # We want to generate images D thinks are real
            
            # Calculate gradients for G
            errG.backward()
            
            # Update G
            optimizerG.step()
            
            # Save Losses for plotting later
            G_losses.append(errG.item())
            D_losses.append(errD.item())
            
            # Update progress bar
            pbar.set_description(f"Epoch [{epoch}/{Config.num_epochs}] d_loss: {errD.item():.4f} g_loss: {errG.item():.4f}")
            
        # Save sample images
        if epoch % Config.sample_interval == 0:
            with torch.no_grad():
                fake_images = netG(fixed_noise).detach().cpu()
                vutils.save_image(fake_images, f"{Config.samples_dir}/fake_samples_epoch_{epoch}.png",
                                normalize=True)
        
        # Save checkpoints
        if epoch % Config.checkpoint_interval == 0:
            torch.save({
                'epoch': epoch,
                'generator_state_dict': netG.state_dict(),
                'discriminator_state_dict': netD.state_dict(),
                'optimizerG_state_dict': optimizerG.state_dict(),
                'optimizerD_state_dict': optimizerD.state_dict(),
                'G_losses': G_losses,
                'D_losses': D_losses,
            }, f"{Config.checkpoint_dir}/checkpoint_epoch_{epoch}.pt")
    
    # Plot training losses
    plt.figure(figsize=(10,5))
    plt.title("Generator and Discriminator Loss During Training")
    plt.plot(G_losses, label="G")
    plt.plot(D_losses, label="D")
    plt.xlabel("Iterations")
    plt.ylabel("Loss")
    plt.legend()
    plt.savefig(f"{Config.samples_dir}/loss_plot.png")
    plt.close()

if __name__ == "__main__":
    train()
