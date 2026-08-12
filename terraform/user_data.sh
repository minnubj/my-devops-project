#!/bin/bash
set -e

dnf update -y

# Java 21
dnf install -y java-21-amazon-corretto

# Docker
dnf install -y docker
systemctl enable --now docker

# AWS CLI
dnf install -y awscli

# Git
dnf install -y git

# Wget
dnf install -y wget

# Jenkins repository
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import \
  https://pkg.jenkins.io/redhat-stable/jenkins.io-2026.key

# Install Jenkins
dnf install -y jenkins

# Start Jenkins
systemctl enable --now jenkins

# Allow Jenkins to use Docker
usermod -aG docker jenkins

# Restart Jenkins after Docker group change
systemctl restart jenkins
