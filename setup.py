setup(
    name="HS DW Load",
    version="1.0.0",
    description="Run ETL scripts on HS datawarehouse",
    author="cSoft",
    author_email="admin@csoft-tech.com",
    license="Proprietary",
    classifiers=[
        "Programming Language :: Python",
        "Programming Language :: Python :: 2",
        "Programming Language :: Python :: 3",
    ],
    packages=["hs_dw"],
    hiddenimports=["mysql-connector-python"],
    include_package_data=True,
    install_requires=[
        "mysql-connector-python","pathlib"
    ],
    entry_points={"console_scripts": ["hs_dw=hs_dw.__main__:main"]},
)