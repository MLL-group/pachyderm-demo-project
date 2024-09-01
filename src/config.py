from dataclasses import dataclass


@dataclass
class Dataset:
    n_samples: int
    n_features: int
    n_classes: int
    flip_y: float


@dataclass
class DemoConfig:
    data_dir: str
    exp_dir: str
    dataset: Dataset
