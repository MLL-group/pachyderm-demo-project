import logging
import pathlib

import hydra
import numpy as np
from hydra.core.config_store import ConfigStore
from sklearn.datasets import make_classification

from config import DemoConfig

cs = ConfigStore.instance()
cs.store(name="config", node=DemoConfig)

log = logging.getLogger(__name__)


@hydra.main(version_base="1.3", config_path="../config", config_name="configuration")
def main(config: DemoConfig):
    features, target = make_classification(
        n_samples=config.dataset.n_samples,
        n_features=config.dataset.n_features,
        n_classes=config.dataset.n_classes,
        flip_y=config.dataset.flip_y,
    )

    data_dir = pathlib.Path(config.data_dir)
    data_dir.mkdir(exist_ok=True, parents=True)

    np.save(data_dir / "features.npy", features)
    np.save(data_dir / "target.npy", target)


if __name__ == "__main__":
    main()
