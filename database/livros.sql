IF OBJECT_ID('dbo.Livros', 'U') IS NOT NULL
    DROP TABLE dbo.Livros;
GO

CREATE TABLE dbo.Livros (
    id INT IDENTITY(1,1) PRIMARY KEY,
    titulo NVARCHAR(150) NOT NULL,
    autor NVARCHAR(120) NOT NULL,
    ano_publicacao INT NOT NULL,
    genero NVARCHAR(80) NOT NULL
);
GO

INSERT INTO dbo.Livros (titulo, autor, ano_publicacao, genero) VALUES
    (N'Dom Casmurro', N'Machado de Assis', 1899, N'Romance'),
    (N'O Pequeno Príncipe', N'Antoine de Saint-Exupéry', 1943, N'Fábula'),
    (N'1984', N'George Orwell', 1949, N'Distopia'),
    (N'Torto Arado', N'Itamar Vieira Junior', 2019, N'Romance'),
    (N'Quarto de Despejo', N'Carolina Maria de Jesus', 1960, N'Diário');
GO

SELECT id, titulo, autor, ano_publicacao, genero
FROM dbo.Livros
ORDER BY id;
GO
