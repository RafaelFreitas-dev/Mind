import { HiX } from "react-icons/hi";

export default function ActiveFilters({
    searchText,
    setSearchText,
    selectedSpecialities,
    setSelectedSpecialities,
    selectedLocals,
    setSelectedLocals,
    selectedRatings,
    setSelectedRatings,
    selectedDays,
    setSelectedDays,
    totalResults
}) {
    const hasActiveFilters = 
        searchText.trim() !== "" ||
        selectedSpecialities.length > 0 ||
        selectedLocals.length > 0 ||
        selectedRatings.length > 0 ||
        selectedDays.length > 0;

    const clearAllFilters = () => {
        setSearchText("");
        setSelectedSpecialities([]);
        setSelectedLocals([]);
        setSelectedRatings([]);
        setSelectedDays([]);
    };

    const removeFilter = (type, value) => {
        switch (type) {
            case 'search':
                setSearchText("");
                break;
            case 'speciality':
                setSelectedSpecialities(prev => prev.filter(item => item !== value));
                break;
            case 'local':
                setSelectedLocals(prev => prev.filter(item => item !== value));
                break;
            case 'rating':
                setSelectedRatings(prev => prev.filter(item => item !== value));
                break;
            case 'day':
                setSelectedDays(prev => prev.filter(item => item !== value));
                break;
            default:
                break;
        }
    };

    if (!hasActiveFilters) return null;

    return (
        <div style={{
            padding: '1rem',
            backgroundColor: '#f5f5f5',
            borderRadius: '8px',
            margin: '1rem 0'
        }}>
            <div style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                marginBottom: '0.5rem'
            }}>
                <span style={{ fontWeight: '600', fontSize: '0.9rem' }}>
                    {totalResults} resultado{totalResults !== 1 ? 's' : ''} encontrado{totalResults !== 1 ? 's' : ''}
                </span>
                <button
                    onClick={clearAllFilters}
                    style={{
                        padding: '0.4rem 0.8rem',
                        backgroundColor: '#e0e0e0',
                        border: 'none',
                        borderRadius: '4px',
                        cursor: 'pointer',
                        fontSize: '0.85rem',
                        fontWeight: '500'
                    }}
                    onMouseOver={(e) => e.target.style.backgroundColor = '#d0d0d0'}
                    onMouseOut={(e) => e.target.style.backgroundColor = '#e0e0e0'}
                >
                    Limpar tudo
                </button>
            </div>
            
            <div style={{
                display: 'flex',
                flexWrap: 'wrap',
                gap: '0.5rem'
            }}>
                {searchText.trim() !== "" && (
                    <FilterTag
                        label={`Busca: "${searchText}"`}
                        onRemove={() => removeFilter('search')}
                    />
                )}
                {selectedSpecialities.map(spec => (
                    <FilterTag
                        key={spec}
                        label={spec}
                        onRemove={() => removeFilter('speciality', spec)}
                    />
                ))}
                {selectedLocals.map(local => (
                    <FilterTag
                        key={local}
                        label={local}
                        onRemove={() => removeFilter('local', local)}
                    />
                ))}
                {selectedRatings.map(rating => (
                    <FilterTag
                        key={rating}
                        label={rating}
                        onRemove={() => removeFilter('rating', rating)}
                    />
                ))}
                {selectedDays.map(day => (
                    <FilterTag
                        key={day}
                        label={day}
                        onRemove={() => removeFilter('day', day)}
                    />
                ))}
            </div>
        </div>
    );
}

function FilterTag({ label, onRemove }) {
    return (
        <div style={{
            display: 'inline-flex',
            alignItems: 'center',
            gap: '0.5rem',
            padding: '0.4rem 0.8rem',
            backgroundColor: '#fff',
            border: '1px solid #ddd',
            borderRadius: '20px',
            fontSize: '0.85rem'
        }}>
            <span>{label}</span>
            <button
                onClick={onRemove}
                style={{
                    background: 'none',
                    border: 'none',
                    cursor: 'pointer',
                    display: 'flex',
                    alignItems: 'center',
                    padding: 0,
                    color: '#666'
                }}
                onMouseOver={(e) => e.target.style.color = '#000'}
                onMouseOut={(e) => e.target.style.color = '#666'}
            >
                <HiX size={16} />
            </button>
        </div>
    );
}